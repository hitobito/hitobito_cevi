# frozen_string_literal: true

#  Copyright (c) 2012-2020, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

class MemberCounter

  # Groups not appearing here are not counted at all.
  TOP_LEVEL = [
    Group::Sport,
    Group::Jungschar,
    Group::TenSing,
    Group::WeitereArbeitsgebiete
  ].freeze
  GROUPS = TOP_LEVEL + [
    Group::SportTeamGruppe,
    Group::WeitereArbeitsgebieteTeamGruppe,
    Group::Froeschli,
    Group::Stufe,
    Group::Gruppe,
    Group::JungscharTeam,
    Group::TenSingTeamGruppe
  ]

  IGNORED_ROLE_NAMES = %w(
    FreierMitarbeiter
  ).freeze

  attr_reader :year, :group

  class << self
    def filtered_roles
      GROUPS.map(&:roles).flatten.reject do |role|
        role_name = role.to_s.demodulize.split('::').last
        role_name =~ /#{IGNORED_ROLE_NAMES.join('|')}/
      end
    end

    def create_counts_for(group)
      census = Census.current
      if census && !current_counts?(group, census)
        new(census.year, group).count!
        census.year
      else
        false
      end
    end

    def current_counts?(group, census = Census.current)
      census && new(census.year, group).exists?
    end

    def counted_roles
      ROLE_MAPPING.values.flatten
    end
  end

  ROLE_MAPPING = { person: filtered_roles }.freeze

  # create a new counter for with the given year and group.
  # beware: the year is only used to store the results and does not
  # specify which roles to consider - only currently not deleted roles are counted.
  def initialize(year, group)
    @year = year
    @group = group
  end

  def count!
    MemberCount.transaction do
      members_by_year.each do |born_in, people|
        count = new_member_count(born_in)
        count_members(count, people)
        count.save!
      end
    end
  end

  def exists?
    MemberCount.where(group: group, year: year).exists?
  end

  def mitgliederorganisation
    @mitgliederorganisation ||= group.mitgliederorganisation
  end

  def members
    Person.joins(:roles).
      where(roles: { group_id: group.self_and_descendants,
                     type: self.class.counted_roles.collect(&:sti_name),
                     deleted_at: nil }).
      distinct
  end

  private

  def members_by_year
    members.includes(:roles).group_by { |p| p.birthday.try(:year) }
  end

  def new_member_count(born_in)
    count = MemberCount.new
    count.group = group
    count.mitgliederorganisation = mitgliederorganisation
    count.year = year
    count.born_in = born_in
    count
  end

  def count_members(count, people)
    people.each do |person|
      increment(count, count_field(person))
    end
  end

  def count_field(person)
    ROLE_MAPPING.each do |field, roles|
      if (person.roles.collect(&:class) & roles).present?
        return person.gender == 'm' ? :"#{field}_m" : :"#{field}_f"
      end
    end
    nil
  end

  def increment(count, field)
    return unless field

    val = count.send(field)
    count.send("#{field}=", val ? val + 1 : 1)
  end

end

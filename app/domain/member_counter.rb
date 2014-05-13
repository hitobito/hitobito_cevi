class MemberCounter

  # Ordered mapping of which roles count in which field.
  # If a role from a field appearing first exists, this
  # one is counted, even if other roles exist as well.
  # E.g. Person has roles Group::Biber::Mitleitung and
  # Group::Pio::Pio => counted as :leiter
  #
  #
  # Groups not appearing here are not counted at all.
  GROUPS = [
    Group::Sport,
    Group::WeitereArbeitsgebiete,
    Group::WeitereArbeitsgebieteTeamGruppe,
    Group::Jungschar,
    Group::Froeschli,
    Group::Stufe,
    Group::Gruppe,
    Group::JungscharTeam,
    Group::TenSing,
    Group::TenSingTeamGruppe
  ]

  IGNORED_ROLE_NAMES = [
    'FreierMitarbeiter',
    'Externer'
  ]

  attr_reader :year, :abteilung

  class << self
    def filtered_roles
      GROUPS.map(&:roles).flatten.reject do |role|
        role_name = role.to_s.demodulize.split('::').last
        role_name =~ /#{IGNORED_ROLE_NAMES.join('|')}/
      end

    end
    def create_counts_for(abteilung)
      census = Census.current
      if census && !current_counts?(abteilung, census)
        new(census.year, abteilung).count!
        census.year
      else
        false
      end
    end

    def current_counts?(abteilung, census = Census.current)
      census && new(census.year, abteilung).exists?
    end

    def counted_roles
      ROLE_MAPPING.values.flatten
    end
  end

  ROLE_MAPPING = { person: filtered_roles }

  # create a new counter for with the given year and abteilung.
  # beware: the year is only used to store the results and does not
  # specify which roles to consider - only currently not deleted roles are counted.
  def initialize(year, abteilung)
    @year = year
    @abteilung = abteilung
  end

  def count!
    MemberCount.transaction do
      count.save!
    end
  end

  def count
    count = new_member_count
    count_members(count, members.includes(:roles))
    count
  end

  def exists?
    MemberCount.where(abteilung_id: abteilung.id, year: year).exists?
  end

  def kantonalverband
    @kantonalverband ||= abteilung.kantonalverband
  end

  def region
    @region ||= abteilung.region
  end

  def members
    Person.joins(:roles).
           where(roles: { group_id: abteilung.self_and_descendants,
                          type: self.class.counted_roles.collect(&:sti_name),
                          deleted_at: nil }).
           uniq
  end

  private

  def new_member_count
    count = MemberCount.new
    count.abteilung = abteilung
    count.kantonalverband = kantonalverband
    count.region = region
    count.year = year
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
        return person.male? ? :"#{field}_m" : :"#{field}_f"
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

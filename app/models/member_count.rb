#  Copyright (c) 2023, Cevi.DB Steuergruppe. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

class MemberCount < ActiveRecord::Base
  belongs_to :group
  belongs_to :mitgliederorganisation, class_name: "Group::Mitgliederorganisation"

  validates_by_schema
  validates :born_in, uniqueness: {scope: [:group_id, :year]}
  validates :person_f, :person_m,
    numericality: {greater_than_or_equal_to: 0, allow_nil: true}

  class << self
    def total_by_mitgliederorganisationen(year)
      totals_by(year, :mitgliederorganisation_id)
    end

    def total_by_groups(year, mitgliederorganisation)
      totals_by(year, :group_id, mitgliederorganisation_id: mitgliederorganisation.id)
    end

    def total_for_dachverband(year)
      totals_by(year, :year).first
    end

    def total_for_group(year, group)
      totals_by(year, :group_id, group_id: group.id).first
    end

    def totals(year)
      select("mitgliederorganisation_id, " \
             "group_id, " \
             "born_in, " \
             "SUM(person_f) AS person_f, " \
             "SUM(person_m) AS person_m")
        .where(year: year)
    end

    def details_for_dachverband(year)
      details(year)
    end

    def details_for_mitgliederorganisation(year, mitgliederorganisation)
      details(year).where(mitgliederorganisation_id: mitgliederorganisation.id)
    end

    def details_for_group(year, group)
      details(year).where(group_id: group.id)
    end

    private

    def totals_by(year, group_by, conditions = {})
      totals(year).where(conditions).group(group_by)
    end

    def details(year)
      totals(year)
        .group(:born_in)
        .order(:born_in)
    end
  end

  def total
    f + m
  end

  def f
    person_f.to_i
  end

  def m
    person_m.to_i
  end
end

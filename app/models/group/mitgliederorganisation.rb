#  Copyright (c) 2023, Cevi.DB Steuergruppe. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

class Group::Mitgliederorganisation < Group
  self.layer = true
  self.event_types = [Event, Event::Course]
  self.contact_group_type = Group::MitgliederorganisationGeschaeftsstelle

  has_many :member_counts

  children Group::MitgliederorganisationVorstand,
    Group::MitgliederorganisationGeschaeftsstelle,
    Group::MitgliederorganisationGremium,
    Group::MitgliederorganisationMitglieder,
    Group::MitgliederorganisationExterne,
    Group::MitgliederorganisationSpender,
    Group::Sektion,
    Group::Ortsgruppe

  ### ROLES

  class Administrator < ::Role
    self.permissions = [:layer_and_below_full]
  end

  roles Administrator

  def census_groups(year)
    MemberCount.total_by_groups(year, self)
  end

  def census_total(year)
    MemberCount.total_by_mitgliederorganisationen(year).find_by(mitgliederorganisation_id: id)
  end

  def census_details(year)
    MemberCount.details_for_mitgliederorganisation(year, self)
  end
end

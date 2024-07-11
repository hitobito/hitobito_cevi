#  Copyright (c) 2023, Cevi.DB Steuergruppe. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

class Group::Dachverband < Group
  self.layer = true
  self.event_types = [Event, Event::Course]
  self.contact_group_type = Group::DachverbandGeschaeftsstelle

  children Group::DachverbandVorstand,
    Group::DachverbandGeschaeftsstelle,
    Group::DachverbandGremium,
    Group::DachverbandMitglieder,
    Group::DachverbandExterne,
    Group::DachverbandSpender,
    Group::Mitgliederorganisation

  ### ROLES

  class Administrator < ::Role
    self.permissions = [:admin, :layer_and_below_full, :impersonation]
  end

  roles Administrator

  def census_groups(year)
    MemberCount.total_by_mitgliederorganisationen(year)
  end

  def census_total(year)
    MemberCount.total_for_dachverband(year)
  end

  def census_details(year)
    MemberCount.details_for_dachverband(year)
  end

  def member_counts
    MemberCount.all
  end
end

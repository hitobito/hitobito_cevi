#  Copyright (c) 2023, Cevi.DB Steuergruppe. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

class Group::DachverbandGremium < Group::Gremium
  children Group::DachverbandGremium

  ### ROLES

  class Leitung < ::Role
    self.permissions = [:layer_read, :group_and_below_full, :contact_data]
  end

  # get the group_and_below_full permission as they should also be able to create events
  class Mitglied < ::Role
    self.permissions = [:layer_read, :group_and_below_full]
  end

  # get the group_and_below_full permission as they should also be able to create events
  class AktiverKursleiter < ::Role
    self.permissions = [:layer_read, :group_and_below_full]
  end

  # get the group_and_below_full permission as they should also be able to create events
  class Kassier < ::Role
    self.permissions = [:layer_read, :group_and_below_full, :finance]
  end

  roles Leitung,
    Mitglied,
    AktiverKursleiter,
    Kassier
end

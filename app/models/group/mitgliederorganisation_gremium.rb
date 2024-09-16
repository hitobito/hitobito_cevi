#  Copyright (c) 2023, Cevi.DB Steuergruppe. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

class Group::MitgliederorganisationGremium < Group::Gremium
  children Group::MitgliederorganisationGremium, Group::MitgliederorganisationExterne

  ### ROLES

  class Leitung < ::Role
    self.permissions = [:layer_and_below_read, :group_and_below_full, :contact_data]
    self.two_factor_authentication_enforced = true
  end

  class Mitglied < ::Role
    self.permissions = [:layer_and_below_read]
    self.two_factor_authentication_enforced = true
  end

  class AktiverKursleiter < ::Role
    self.permissions = [:layer_and_below_read]
    self.two_factor_authentication_enforced = true
  end

  class Ausbildungsmitglied < ::Role
    self.permissions = [:layer_and_below_read]
    self.two_factor_authentication_enforced = true
  end

  class Kassier < ::Role
    self.permissions = [:layer_and_below_read, :finance]
    self.two_factor_authentication_enforced = true
  end

  roles Leitung,
    Mitglied,
    AktiverKursleiter,
    Ausbildungsmitglied,
    Kassier
end

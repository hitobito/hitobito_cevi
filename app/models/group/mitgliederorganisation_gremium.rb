# encoding: utf-8

#  Copyright (c) 2023, Cevi.DB Steuergruppe. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

class Group::MitgliederorganisationGremium < Group::Gremium

  children Group::MitgliederorganisationGremium


  ### ROLES

  class Leitung < ::Role
    self.permissions = [:layer_and_below_read, :group_and_below_full, :contact_data]
  end

  class Mitglied < ::Role
    self.permissions = [:layer_and_below_read]
  end

  class AktiverKursleiter < ::Role
    self.permissions = [:layer_and_below_read]
  end

  class Ausbildungsmitglied < ::Role
    self.permissions = [:layer_and_below_read]
  end

  class Kassier < ::Role
    self.permissions = [:layer_and_below_read, :finance]
  end

  roles Leitung,
        Mitglied,
        AktiverKursleiter,
        Ausbildungsmitglied,
        Kassier

end

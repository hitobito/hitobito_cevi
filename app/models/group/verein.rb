#  Copyright (c) 2023, Cevi.DB Steuergruppe. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

class Group::Verein < Group
  self.layer = true

  children Group::VereinVorstand,
    Group::VereinMitglieder,
    Group::VereinExterne,
    Group::VereinSpender

  ### ROLES

  class Adressverantwortlicher < ::Role
    self.permissions = [:layer_and_below_full]
  end

  class Mitglied < ::Role
    self.permissions = [:group_read]

    self.visible_from_above = false
  end

  class FreierMitarbeiter < ::Role
    self.permissions = [:layer_and_below_read]
  end

  roles Adressverantwortlicher,
    Mitglied,
    FreierMitarbeiter
end

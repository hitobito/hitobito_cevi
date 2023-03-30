# encoding: utf-8

#  Copyright (c) 2023, Cevi.DB Steuergruppe. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

class Group::WeitereArbeitsgebiete < Group
  include CensusGroup

  self.layer = true

  children Group::WeitereArbeitsgebieteExterne,
           Group::WeitereArbeitsgebieteTeamGruppe,
           Group::WeitereArbeitsgebieteSpender

  ### ROLES

  class Adressverantwortlicher < ::Role
    self.permissions = [:layer_and_below_full]
  end

  class Finanzverantwortlicher < ::Role
    self.permissions = [:layer_and_below_read, :finance, :financials]
  end

  class Hauptleitung < ::Role
    self.permissions = [:layer_and_below_full, :contact_data]
  end

  class Materialverantwortlicher < ::Role
    self.permissions = [:layer_and_below_read, :contact_data]
  end

  class Leiter < ::Role
    self.permissions = [:group_and_below_full]
  end

  class Mitglied < ::Role
    self.permissions = [:group_read]

    self.visible_from_above = false
  end

  class FreierMitarbeiter < ::Role
    self.permissions = [:layer_and_below_read]
  end

  roles Adressverantwortlicher,
        Finanzverantwortlicher,
        Hauptleitung,
        Materialverantwortlicher,
        Leiter,
        Mitglied,
        FreierMitarbeiter

end

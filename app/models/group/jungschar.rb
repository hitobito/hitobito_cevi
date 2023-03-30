# encoding: utf-8

#  Copyright (c) 2023, Cevi.DB Steuergruppe. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

class Group::Jungschar < Group
  include CensusGroup

  children JungscharSpender

  self.layer = true

  ### ROLES

  class Abteilungsleiter < ::Role
    self.permissions = [:layer_and_below_full, :contact_data]
  end

  class Coach < ::Role
    self.permissions = [:layer_and_below_full, :approve_applications]
  end

  class Finanzverantwortlicher < ::Role
    self.permissions = [:layer_and_below_read, :finance, :financials]
  end

  class Adressverwalter < ::Role
    self.permissions = [:layer_and_below_full]
  end

  class Aktuar < ::Role
    self.permissions = [:layer_and_below_read]
  end

  class Busverwalter < ::Role
    self.permissions = [:layer_and_below_read, :contact_data]
  end

  class FreierMitarbeiter < ::Role
    self.permissions = [:layer_and_below_read]
  end

  class Hausverantwortlicher < ::Role
    self.permissions = [:layer_and_below_read, :contact_data]
  end

  class Input < ::Role
    self.permissions = [:layer_and_below_read]
  end

  class Laedeliverantwortlicher < ::Role
    self.permissions = [:layer_and_below_read]
  end

  class Redaktor < ::Role
    self.permissions = [:layer_and_below_read]
  end

  class Regionaltreffenvertreter < ::Role
    self.permissions = [:layer_and_below_read]
  end

  class Webmaster < ::Role
    self.permissions = [:layer_and_below_read]
  end

  class Werbung < ::Role
    self.permissions = [:layer_and_below_read]
  end

  class Materialverantwortlicher < ::Role
    self.permissions = [:layer_and_below_read, :contact_data]
  end

  class KontaktRegionalzeitschrift < ::Role
    self.permissions = [:layer_and_below_read]
  end

  class VerantwortlicherPSA < ::Role
    self.permissions = [:layer_and_below_read]
  end

  class Jugendarbeiter < ::Role
    self.permissions = [:layer_and_below_read]
  end

  roles Abteilungsleiter,
        Coach,
        Finanzverantwortlicher,
        Adressverwalter,
        Aktuar,
        Busverwalter,
        FreierMitarbeiter,
        Hausverantwortlicher,
        Input,
        Laedeliverantwortlicher,
        Redaktor,
        Regionaltreffenvertreter,
        Webmaster,
        Werbung,
        Materialverantwortlicher,
        KontaktRegionalzeitschrift,
        VerantwortlicherPSA,
        Jugendarbeiter

  children Group::JungscharExterne,
           Group::Froeschli,
           Group::Stufe,
           Group::JungscharTeam

end

# encoding: utf-8

#  Copyright (c) 2023, Cevi.DB Steuergruppe. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.
#

class Group::TenSing < Group
  include CensusGroup

  self.layer = true

  ### INSTANCE METHODS

  def mitgliederorganisation
    ancestors.find_by(type: Group::Mitgliederorganisation.sti_name)
  end

  ### ROLES

  class Hauptleiter < ::Role
    self.permissions = [:layer_and_below_full, :contact_data]
  end

  class Mitglied < ::Role
    self.permissions = [:group_read]
  end

  class Arrangeur < ::Role
    self.permissions = [:layer_and_below_read]
  end

  class Adressverwalter < ::Role
    self.permissions = [:layer_and_below_full]
  end

  class Aktuar < ::Role
    self.permissions = [:layer_and_below_read]
  end

  class Finanzverantwortlicher < ::Role
    self.permissions = [:layer_and_below_read, :finance, :financials]
  end

  class FreierMitarbeiter < ::Role
    self.permissions = [:layer_and_below_read]
  end

  class InputLeiter < ::Role
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

  class WerbeteamLeitender < ::Role
    self.permissions = [:layer_and_below_read]
  end

  class Dirigent < ::Role
    self.permissions = [:layer_and_below_read]
  end

  class Chorleiter < ::Role
    self.permissions = [:layer_and_below_read]
  end

  class Chorsaenger < ::Role
    self.permissions = [:group_read]
  end

  class VideoLeiter < ::Role
    self.permissions = [:layer_and_below_read]
  end

  class StagedesignLeiter < ::Role
    self.permissions = [:layer_and_below_read]
  end

  class Stagedesigner < ::Role
    self.permissions = [:group_read]
  end

  class DJ < ::Role
    self.permissions = [:layer_and_below_read]
  end

  class VerantwortlicherLagerWeekends < ::Role
    self.permissions = [:layer_and_below_read]
  end

  class Jugendarbeiter < ::Role
    self.permissions = [:layer_and_below_read]
  end

  class BandLeiter < ::Role
    self.permissions = [:layer_and_below_read]
  end

  class Bandmitglied < ::Role
    self.permissions = [:group_read]
  end

  class TanzLeiter < ::Role
    self.permissions = [:layer_and_below_read]
  end

  class Taenzer < ::Role
    self.permissions = [:group_read]
  end

  class TechnikLeiter < ::Role
    self.permissions = [:layer_and_below_read]
  end

  class Techniker < ::Role
    self.permissions = [:group_read]
  end

  class TheaterLeiter < ::Role
    self.permissions = [:layer_and_below_read]
  end

  class Schauspieler < ::Role
    self.permissions = [:group_read]
  end

  roles Hauptleiter,
        Mitglied,
        Arrangeur,
        Adressverwalter,
        Aktuar,
        Finanzverantwortlicher,
        FreierMitarbeiter,
        InputLeiter,
        Redaktor,
        Regionaltreffenvertreter,
        Webmaster,
        WerbeteamLeitender,
        Dirigent,
        Chorleiter,
        Chorsaenger,
        VideoLeiter,
        StagedesignLeiter,
        Stagedesigner,
        DJ,
        VerantwortlicherLagerWeekends,
        Jugendarbeiter,
        BandLeiter,
        Bandmitglied,
        TanzLeiter,
        Taenzer,
        TechnikLeiter,
        Techniker,
        TheaterLeiter,
        Schauspieler


  # TenSingTeamGruppe has TenSing roles
  # need to place children after roles are defined
  children Group::TenSingTeamGruppe,
           Group::TenSingExterne,
           Group::TenSingSpender
end

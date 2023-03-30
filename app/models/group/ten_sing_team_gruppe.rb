# encoding: utf-8

#  Copyright (c) 2023, Cevi.DB Steuergruppe. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

class Group::TenSingTeamGruppe < Group

  children Group::TenSingTeamGruppe


  ### ROLES

  class Adressverantwortliche < ::Role
    self.permissions = [:group_and_below_full]
  end

  roles Adressverantwortliche,
        Group::TenSing::Hauptleiter,
        Group::TenSing::Mitglied,
        Group::TenSing::Arrangeur,
        Group::TenSing::Adressverwalter,
        Group::TenSing::Aktuar,
        Group::TenSing::Finanzverantwortlicher,
        Group::TenSing::FreierMitarbeiter,
        Group::TenSing::InputLeiter,
        Group::TenSing::Redaktor,
        Group::TenSing::Regionaltreffenvertreter,
        Group::TenSing::Webmaster,
        Group::TenSing::WerbeteamLeitender,
        Group::TenSing::Dirigent,
        Group::TenSing::Chorleiter,
        Group::TenSing::Chorsaenger,
        Group::TenSing::VideoLeiter,
        Group::TenSing::StagedesignLeiter,
        Group::TenSing::Stagedesigner,
        Group::TenSing::DJ,
        Group::TenSing::VerantwortlicherLagerWeekends,
        Group::TenSing::Jugendarbeiter,
        Group::TenSing::BandLeiter,
        Group::TenSing::Bandmitglied,
        Group::TenSing::TanzLeiter,
        Group::TenSing::Taenzer,
        Group::TenSing::TechnikLeiter,
        Group::TenSing::Techniker,
        Group::TenSing::TheaterLeiter,
        Group::TenSing::Schauspieler

end

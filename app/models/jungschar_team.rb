class Group::JungscharTeam < Group

  ### ROLES

  class Leitung < ::Role
    self.permissions = [:group_full]
  end

  class Mitarbeiter < ::Role
    self.permissions = [:group_read]
  end

  roles Group::Stufe::Abteilungsleiter,
        Group::Stufe::Coach,
        Group::Stufe::Finanzverantwortlicher,
        Group::Stufe::Adressverwalter,
        Group::Stufe::Aktuar,
        Group::Stufe::Busverwalter,
        Group::Stufe::FreierMitarbeiter,
        Group::Stufe::Hausverantwortlicher,
        Group::Stufe::Input,
        Group::Stufe::Laedeliverantwortliche,
        Group::Stufe::Redaktor,
        Group::Stufe::Regionaltreffenvertreter,
        Group::Stufe::Webmaster,
        Group::Stufe::Werbung,
        Group::Stufe::Materialverantwortlicher,
        Group::Stufe::KontaktRegionalzeitschrift,
        Group::Stufe::VerantwortlicherPSA,
        Group::Stufe::Jugendarbeiter,
        Leitung,
        Mitarbeiter

end

class Group::JungscharTeam < Group

  ### ROLES

  class Leitung < ::Role
    self.permissions = [:group_full]
  end

  class Mitarbeiter < ::Role
    self.permissions = [:group_read]
  end

  roles Group::Jungschar::Abteilungsleiter,
        Group::Jungschar::Coach,
        Group::Jungschar::Finanzverantwortlicher,
        Group::Jungschar::Adressverwalter,
        Group::Jungschar::Aktuar,
        Group::Jungschar::Busverwalter,
        Group::Jungschar::FreierMitarbeiter,
        Group::Jungschar::Hausverantwortlicher,
        Group::Jungschar::Input,
        Group::Jungschar::Laedeliverantwortliche,
        Group::Jungschar::Redaktor,
        Group::Jungschar::Regionaltreffenvertreter,
        Group::Jungschar::Webmaster,
        Group::Jungschar::Werbung,
        Group::Jungschar::Materialverantwortlicher,
        Group::Jungschar::KontaktRegionalzeitschrift,
        Group::Jungschar::VerantwortlicherPSA,
        Group::Jungschar::Jugendarbeiter,
        Leitung,
        Mitarbeiter

end

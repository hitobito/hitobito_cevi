class Group::Jungschar < Group

  self.layer = true

  ### ROLES

  class Abteilungsleiter < ::Role
    self.permissions = [:layer_full, :public]
  end

  class Coach < ::Role
    self.permissions = [:layer_read]
  end

  class Finanzverantwortlicher < ::Role
    self.permissions = [:layer_read, :financials]
  end

  class Adressverwalter < ::Role
    self.permissions = [:layer_full]
  end

  class Aktuar < ::Role
    self.permissions = [:layer_read]
  end

  class Busverwalter < ::Role
    self.permissions = [:layer_read, :public]
  end

  class FreierMitarbeiter < ::Role
    self.permissions = [:layer_read]
  end

  class Hausverantwortlicher < ::Role
    self.permissions = [:layer_read, :public]
  end

  class Input < ::Role
    self.permissions = [:layer_read]
  end

  class Laedeliverantwortlicher < ::Role
    self.permissions = [:layer_read]
  end

  class Redaktor < ::Role
    self.permissions = [:layer_read]
  end

  class Regionaltreffenvertreter < ::Role
    self.permissions = [:layer_read]
  end

  class Webmaster < ::Role
    self.permissions = [:layer_read]
  end

  class Werbung < ::Role
    self.permissions = [:layer_read]
  end

  class Materialverantwortlicher < ::Role
    self.permissions = [:layer_read, :public]
  end

  class KontaktRegionalzeitschrift < ::Role
    self.permissions = [:layer_read]
  end

  class VerantwortlicherPSA < ::Role
    self.permissions = [:layer_read]
  end

  class Jugendarbeiter < ::Role
    self.permissions = [:layer_read]
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

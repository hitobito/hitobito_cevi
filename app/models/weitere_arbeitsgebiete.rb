class Group::WeitereArbeitsgebiete < Group

  self.layer = true

  children Group::Leitungsteam,
           Group::WeitereArbeitsgebieteTeam


  ### ROLES

  class Adressverantwortlicher < ::Role
    self.permissions = [:layer_full]
  end

  class Finanzverantwortlicher < ::Role
    self.permissions = [:layer_read, :financials]
  end

  class Hauptleitung < ::Role
    self.permissions = [:layer_full, :public]
  end

  class Materialverantwortlicher < ::Role
    self.permissions = [:layer_read, :public]
  end

  class Leiter < ::Role
    self.permissions = [:group_full]
  end

  class Mitglied < ::Role
    self.permissions = [:group_read]
  end

  class FreierMitarbeiter < ::Role
    self.permissions = [:layer_read]
  end

  roles Adressverantwortlicher,
        Finanzverantwortlicher,
        Hauptleitung,
        Materialverantwortlicher,
        Leiter,
        Mitglied,
        FreierMitarbeiter

end

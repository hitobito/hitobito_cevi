class Group::MitgliederorganisationGremium < Group::Gremium

  children Group::MitgliederorganisationGremium


  ### ROLES

  class Leitung < ::Role
    self.permissions = [:layer_read, :group_full, :public]
  end

  class Mitglied < ::Role
    self.permissions = [:layer_read]
  end

  class AktiverKursleiter < ::Role
    self.permissions = [:layer_read]
  end

  roles Leitung,
        Mitglied,
        AktiverKursleiter

end

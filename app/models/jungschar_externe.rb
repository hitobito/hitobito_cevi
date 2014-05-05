class Group::JungscharExterne < Group::Externe

  children Group::JungscharExterne


  ### ROLES

  class Verantwortlicher < ::Role
    self.permissions = [:group_full]
  end

  class Jugendarbeiter < ::Role
    self.permissions = []
  end

  class Externe < ::Role
    self.permissions = []
  end

  class Goetti < ::Role
    self.permissions = []
  end

  roles Verantwortlicher,
        Jugendarbeiter,
        Externe,
        Goetti

end

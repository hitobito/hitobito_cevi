class Group::Froeschli < Group

  children Group::Froeschli


  ### ROLES

  class Froeschlihauptleiter < ::Role
    self.permissions = [:layer_read, :group_full]
  end

  class Froeschlileiter < ::Role
    self.permissions = [:layer_read]
  end

  class Teilnehmer < ::Role
    self.permissions = [:group_read]
  end

  roles Froeschlihauptleiter,
        Froeschlileiter,
        Teilnehmer

end

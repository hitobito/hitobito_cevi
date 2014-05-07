class Group::Stufe < Group

  ### ROLES

  class Stufenleiter < ::Role
    self.permissions = [:layer_read, :group_full]
  end

  class MiniChef < ::Role
    self.permissions = [:layer_read, :group_full]
  end

  class Gruppenleiter < ::Role
    self.permissions = [:layer_read, :group_full]
  end

  class Minigruppenleiter < ::Role
    self.permissions = [:layer_read, :group_full]
  end

  class Helfer < ::Role
    self.permissions = [:layer_read]
  end

  class Teilnehmer < ::Role
    self.permissions = [:group_read]
  end

  children Group::Gruppe

  roles Stufenleiter,
        MiniChef,
        Gruppenleiter,
        Minigruppenleiter,
        Helfer,
        Teilnehmer

end

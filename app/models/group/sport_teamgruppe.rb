class Group::SportTeamGruppe < Group

  children Group::SportTeamGruppe


  ### ROLES

  class Leiter < ::Role
    self.permissions = [:group_full]
  end

  class Mitglied < ::Role
    self.permissions = [:group_read]
  end

  roles Leiter,
        Mitglied

end

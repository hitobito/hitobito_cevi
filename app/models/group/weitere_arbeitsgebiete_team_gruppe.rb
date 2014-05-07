class Group::WeitereArbeitsgebieteTeamGruppe < Group

  children Group::WeitereArbeitsgebieteTeamGruppe


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

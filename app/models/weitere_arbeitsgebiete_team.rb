class Group::WeitereArbeitsgebieteTeam < Group

  children Group::WeitereArbeitsgebieteTeam


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

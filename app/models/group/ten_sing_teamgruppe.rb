class Group::TenSingTeamGruppe < Group

  children Group::TenSingTeamGruppe


  ### ROLES

  class Adressverantwortliche < ::Role
    self.permissions = [:group_full]
  end

  roles Adressverantwortliche

end

class Group::DachverbandMitglieder < Group::Mitglieder

  children Group::DachverbandMitglieder


  ### ROLES

  class Adressverwalter < ::Role
    self.permissions = [:group_full]
  end

  class Mitglied < ::Role; end

  roles Adressverwalter,
        Mitglied

end

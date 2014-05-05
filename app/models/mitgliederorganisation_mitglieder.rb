class Group::MitgliederorganisationMitglieder < Group::Mitglieder

  children Group::MitgliederorganisationMitglieder


  ### ROLES

  class Adressverwalter < ::Role
    self.permissions = [:group_full]
  end

  class Mitglied < ::Role; end

  roles Adressverwalter,
        Mitglied

end

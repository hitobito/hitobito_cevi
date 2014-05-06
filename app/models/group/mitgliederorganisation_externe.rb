class Group::MitgliederorganisationExterne < Group::Externe

  children Group::MitgliederorganisationExterne


  ### ROLES

  class Adressverwalter < ::Role
    self.permissions = [:group_full]
  end

  class Externer < ::Role; end

  roles Adressverwalter,
        Externer

end

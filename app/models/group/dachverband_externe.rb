class Group::DachverbandExterne < Group::Externe

  children Group::DachverbandExterne

  ### ROLES

  class Adressverwalter < ::Role
    self.permissions = [:group_full]
  end

  class Externer < ::Role; end

  roles Adressverwalter,
        Externer

end

class Group::SportExterne < Group::Externe

  children Group::SportExterne


  ### ROLES

  class Verantwortlicher < ::Role
    self.permissions = [:group_full]
  end

  class Externer < ::Role; end

  roles Verantwortlicher,
        Externer

end

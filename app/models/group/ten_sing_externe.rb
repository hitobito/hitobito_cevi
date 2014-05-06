class Group::TenSingExterne < Group::Externe

  children Group::TenSingExterne


  ## ROLES

  class Verantwortlicher < ::Role
    self.permissions = [:group_full]
  end

  class Externer < ::Role; end

  class Jugendarbeiter < ::Role; end

  roles Verantwortlicher,
        Externer,
        Jugendarbeiter

end

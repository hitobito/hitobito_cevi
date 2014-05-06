class Group::TenSingExterne < Group::Externe

  children Group::TenSingExterne


  ## ROLES

  class Verantwortlicher < ::Role
    self.permissions = [:group_full]
  end

  class Externe < ::Role; end

  class Jugendarbeiter < ::Role; end

  roles Verantwortlicher,
        Extere,
        Jugendarbeiter

end

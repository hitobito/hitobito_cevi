class Group::SportExterne < Group::Externe

  children Group::SportExterne


  ### ROLES

  class Verantwortlicher < ::Role
    self.permissions = [:group_full]
  end

  class Externe < ::Role; end

  roles Verantwortlicher,
        Extere

end

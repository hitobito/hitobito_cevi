class Group::WeitereArbeitsgebieteExterne < Group::Externe

  children Group::WeitereArbeitsgebieteExterne


  ### ROLES

  class Verantwortlicher < ::Role
    self.permissions = [:group_full]
  end

  class Externe < ::Role; end

  roles Verantwortlicher,
        Extere

end

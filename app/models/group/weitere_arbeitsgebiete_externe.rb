class Group::WeitereArbeitsgebieteExterne < Group::Externe

  children Group::WeitereArbeitsgebieteExterne


  ### ROLES

  class Verantwortlicher < ::Role
    self.permissions = [:group_full]
  end

  class Externer < ::Role; end

  roles Verantwortlicher,
        Externer

end

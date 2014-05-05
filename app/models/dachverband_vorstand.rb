class Group::DachverbandVorstand < Group::Vorstand

  ### ROLES

  class Praesidium < ::Role
    self.permissions = [:layer_read, :group_full, :public]
  end

  class Finanzverantwortlicher < ::Role
    self.permissions = [:layer_read, :financials, :public]
  end

  class Mitglied < ::Role
    self.permissions = [:layer_read, :public]
  end

  roles Praesidium,
        Finanzverantwortlicher,
        Mitglied

end

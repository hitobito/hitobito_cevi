class Group::DachverbandGeschaeftsstelle < Group::Geschaeftsstelle

  ### ROLES

  class Geschaeftsleiter < ::Role
    self.permissions = [:layer_full, :public, :admin]
  end

  class Angestellter < ::Role
    self.permissions = [:layer_full, :public, :admin]
  end

  class Finanzverantwortlicher < ::Role
    self.permissions = [:layer_full, :financials, :public, :admin]
  end

  roles Geschaeftsleiter,
        Angestellter,
        Finanzverantwortlicher

end

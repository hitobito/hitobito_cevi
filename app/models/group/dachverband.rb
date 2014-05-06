class Group::Dachverband < Group

  self.layer = true

  children Group::Mitgliederorganisation,
           Group::DachverbandVorstand,
           Group::DachverbandGeschaeftsstelle,
           Group::DachverbandGremium,
           Group::DachverbandMitglieder,
           Group::DachverbandExterne


  ### ROLES

  class Administrator < ::Role
    self.permissions = [:admin, :layer_full]
  end

  roles Administrator

end

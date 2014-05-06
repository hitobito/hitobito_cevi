class Group::Mitgliederorganisation < Group

  self.layer = true

  children Group::Sektion,
           Group::Ortsgruppe,
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

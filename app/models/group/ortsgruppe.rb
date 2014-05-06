class Group::Ortsgruppe < Group

  self.layer = true

  children Group::Jungschar,
           Group::Verein,
           Group::TenSing,
           Group::Sport,
           Group::WeitereArbeitsgebiete


  ### ROLES

  class AdministratorCeviDB < ::Role
    self.permissions = [:layer_full]
  end

  roles AdministratorCeviDB

end

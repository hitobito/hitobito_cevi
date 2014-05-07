# == Schema Information
#
# Table name: groups
#
#  id             :integer          not null, primary key
#  parent_id      :integer
#  lft            :integer
#  rgt            :integer
#  name           :string(255)      not null
#  short_name     :string(31)
#  type           :string(255)      not null
#  email          :string(255)
#  address        :string(1024)
#  zip_code       :integer
#  town           :string(255)
#  country        :string(255)
#  contact_id     :integer
#  created_at     :datetime
#  updated_at     :datetime
#  deleted_at     :datetime
#  layer_group_id :integer
#  creator_id     :integer
#  updater_id     :integer
#  deleter_id     :integer
#

class Group::WeitereArbeitsgebiete < Group

  self.layer = true

  children Group::WeitereArbeitsgebieteExterne,
           Group::WeitereArbeitsgebieteTeamGruppe


  ### ROLES

  class Adressverantwortlicher < ::Role
    self.permissions = [:layer_full]
  end

  class Finanzverantwortlicher < ::Role
    self.permissions = [:layer_read, :financials]
  end

  class Hauptleitung < ::Role
    self.permissions = [:layer_full, :public]
  end

  class Materialverantwortlicher < ::Role
    self.permissions = [:layer_read, :public]
  end

  class Leiter < ::Role
    self.permissions = [:group_full]
  end

  class Mitglied < ::Role
    self.permissions = [:group_read]
  end

  class FreierMitarbeiter < ::Role
    self.permissions = [:layer_read]
  end

  roles Adressverantwortlicher,
        Finanzverantwortlicher,
        Hauptleitung,
        Materialverantwortlicher,
        Leiter,
        Mitglied,
        FreierMitarbeiter

end

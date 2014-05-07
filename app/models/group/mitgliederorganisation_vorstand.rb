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

class Group::MitgliederorganisationVorstand < Group::Vorstand

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

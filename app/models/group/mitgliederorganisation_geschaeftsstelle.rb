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

class Group::MitgliederorganisationGeschaeftsstelle < Group::Geschaeftsstelle

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

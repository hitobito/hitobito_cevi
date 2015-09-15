class AddPeopleContactDataVisible < ActiveRecord::Migration
  def change
    types = Role.all_types.select { |r| r.permissions.include?(:contact_data) }
    Person.where(id: Role.where(type: types).select(:person_id)).update_all(contact_data_visible: true)
  end
end

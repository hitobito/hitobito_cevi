class AddOldDataToPeople < ActiveRecord::Migration
  def change
    add_column(:people, :old_data, :text)
  end
end

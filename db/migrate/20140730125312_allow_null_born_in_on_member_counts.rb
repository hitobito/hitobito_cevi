class AllowNullBornInOnMemberCounts < ActiveRecord::Migration
  def change
    change_column(:member_counts, :born_in, :integer, null: false)
  end
end

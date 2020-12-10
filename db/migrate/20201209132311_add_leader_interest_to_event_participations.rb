class AddLeaderInterestToEventParticipations < ActiveRecord::Migration[6.0]
  def change
    add_column :event_participations, :leader_interest, :boolean, null: false, default: false
  end
end

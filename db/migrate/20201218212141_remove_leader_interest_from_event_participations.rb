class RemoveLeaderInterestFromEventParticipations < ActiveRecord::Migration[6.0]
  def change
    remove_column :event_participations, :leader_interest, :boolean, null: false, default: false
  end
end

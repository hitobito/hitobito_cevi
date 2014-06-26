class AdditionalEventParticipationColumns < ActiveRecord::Migration
  def change
    add_column(:event_participations, :internal_comment, :text)
    add_column(:event_participations, :payed, :boolean)
  end
end

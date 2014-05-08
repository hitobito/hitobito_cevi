class CreateCensus < ActiveRecord::Migration
  def change
    create_table :censuses do |t|
      t.integer :year, null: false
      t.date    :start_at
      t.date    :finish_at
    end

    add_index :censuses, :year, unique: true

    create_table :member_counts do |t|
      t.integer :mitgliederorganisation_id, null: false
      t.integer :year, null: false
      t.integer :person_f
      t.integer :person_w
    end

    add_index :member_counts, [:mitgliederorganisation_id, :year]
  end
end

# encoding: utf-8

#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

class CreateCensus < ActiveRecord::Migration
  def change
    create_table :censuses do |t|
      t.integer :year, null: false
      t.date    :start_at
      t.date    :finish_at
    end

    add_index :censuses, :year, unique: true

    create_table :member_counts do |t|
      t.integer :group_id, null: false
      t.integer :mitgliederorganisation_id, null: false
      t.integer :year, null: false
      t.integer :born_in, null: false
      t.integer :person_f
      t.integer :person_m
    end

    add_index :member_counts, [:mitgliederorganisation_id, :year]
    add_index :member_counts, [:group_id, :year]
  end
end

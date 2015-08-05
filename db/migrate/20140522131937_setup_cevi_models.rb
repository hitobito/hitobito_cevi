# encoding: utf-8

#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

class SetupCeviModels < ActiveRecord::Migration
  def change
    add_column :people, :title, :string

    add_column :people, :profession, :string
    add_column :people, :joined, :date
    add_column :people, :ahv_number_old, :string

    unless column_exists?(:people, :nationality)
      add_column :people, :nationality, :string
    end

    add_column :people, :salutation_parents, :string
    add_column :people, :name_parents, :string
    add_column :people, :member_card_number, :integer

    add_column :people, :salutation, :string
    add_column :people, :canton, :string
    add_column :people, :confession, :string
    add_column :people, :correspondence_language, :string

    add_column :groups, :founding_date, :date
  end
end

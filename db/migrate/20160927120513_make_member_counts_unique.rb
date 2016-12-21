# encoding: utf-8

#  Copyright (c) 2012-2016, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

class MakeMemberCountsUnique < ActiveRecord::Migration
  def change
    add_index :member_counts,
              [:year, :group_id, :born_in],
              unique: true,
              name: 'index_member_counts_unique_per_year'
  end
end

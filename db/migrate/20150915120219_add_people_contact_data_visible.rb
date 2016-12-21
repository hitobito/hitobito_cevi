# encoding: utf-8

#  Copyright (c) 2012-2015, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

class AddPeopleContactDataVisible < ActiveRecord::Migration
  def change
    types = Role.all_types.select { |r| r.permissions.include?(:contact_data) }
    Person.where(id: Role.where(type: types).select(:person_id)).update_all(contact_data_visible: true)
  end
end

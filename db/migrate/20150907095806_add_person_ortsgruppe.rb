# encoding: utf-8

#  Copyright (c) 2012-2015, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

class AddPersonOrtsgruppe < ActiveRecord::Migration[4.2]
  def change
    add_column(:people, :ortsgruppe_id, :integer)

    reversible do |dir|
      dir.up do
        update_persons_ortsgruppe
      end
    end
  end

  private

  def update_persons_ortsgruppe
    Person.find_each do |person|
      ortsgruppen = find_person_ortsgruppen(person)
      if ortsgruppen.size == 1
        person.update_column(:ortsgruppe_id, ortsgruppen.first.id)
      end
    end
  end

  def find_person_ortsgruppen(person)
    person.roles.collect do |role|
      person_ortsgruppe_for(role.group)
    end.uniq.compact
  end

  def person_ortsgruppe_for(group)
    group.hierarchy.select(:id).find_by(type: ::Group::Ortsgruppe.sti_name)
  end

end

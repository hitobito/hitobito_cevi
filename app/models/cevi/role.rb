# encoding: utf-8

#  Copyright (c) 2012-2015, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

module Cevi::Role
  extend ActiveSupport::Concern

  included do
    after_create :reset_person_ortsgruppe!, if: :ortsgruppe_id_column_available?
  end

  private

  def reset_person_ortsgruppe!
    unless person.ortsgruppe_id
      groups = find_person_ortsgruppen
      if groups.size == 1
        person.update_column(:ortsgruppe_id, groups.first.id)
      end
    end
    true
  end

  def find_person_ortsgruppen
    person.roles.to_a.collect do |role|
      person_ortsgruppe_for(role.group)
    end.uniq.compact
  end

  def person_ortsgruppe_for(group)
    group.hierarchy.select(:id).find_by(type: ::Group::Ortsgruppe.sti_name)
  end

  # Missing when core person is seeded and wagon migrations have not be run
  def ortsgruppe_id_column_available?
    Person.column_names.include?('ortsgruppe_id')
  end

end

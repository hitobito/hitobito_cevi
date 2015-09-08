# encoding: utf-8

#  Copyright (c) 2012-2015, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

module Cevi::Role
  extend ActiveSupport::Concern

  included do
    after_create :reset_person_ortsgruppe!
  end

  private

  def reset_person_ortsgruppe!
    person.update_column(:ortsgruppe_id, find_person_ortsgruppe.try(:id))
    true
  end

  def find_person_ortsgruppe
    if person.roles.to_a.size == 1 && person.ortsgruppe_id.nil?
      person_ortsgruppe_for(group)
    end
  end

  def person_ortsgruppe_for(group)
    group.hierarchy.select(:id).find_by(type: ::Group::Ortsgruppe.sti_name)
  end
end

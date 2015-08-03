# encoding: utf-8

#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

module Cevi::Event::Course
  extend ActiveSupport::Concern

  included do
    self.used_attributes += [:application_contact_id]

    ### ASSOCIATIONS

    belongs_to :application_contact, class_name: 'Group'
    belongs_to :condition, class_name: 'Condition'

    validate :validate_application_contact
  end

  def possible_contact_groups
    groups.each_with_object([]) do |g, contact_groups|
      type = g.class.contact_group_type
      if type
        children = g.children.where(type: type.sti_name).without_deleted
        contact_groups.concat(children)
      end
    end
  end

  private

  def validate_application_contact
    unless possible_contact_groups.include?(application_contact)
      errors.add(:base, :geschaeftsstelle_missing)
    end
  end

end

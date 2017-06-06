# encoding: utf-8

#  Copyright (c) 2012-2017, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

module Cevi::EventAbility
  extend ActiveSupport::Concern

  included do
    on(Event::Course) do
      permission(:layer_and_below_read).
        may(:index_participations).
        in_same_layer_or_below_if_ausbildungsmitglied
    end
  end

  def in_same_layer_or_below_if_ausbildungsmitglied
    contains_any?(ausbildungs_layer_ids, event_hierarchy_ids)
  end

  private

  def ausbildungs_layer_ids
    user.
      roles.
      select { |r| r.is_a?(Group::MitgliederorganisationGremium::Ausbildungsmitglied) }.
      map { |r| r.group.layer_group_id }
  end

  def event_hierarchy_ids
    event.groups.collect(&:layer_hierarchy).flatten.collect(&:id).uniq
  end

end

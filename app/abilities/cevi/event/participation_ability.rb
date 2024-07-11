# frozen_string_literal: true

#  Copyright (c) 2012-2020, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

module Cevi::Event::ParticipationAbility
  extend ActiveSupport::Concern

  included do
    on(Event::Participation) do
      permission(:see_invisible_from_above)
        .may(:create_tentative)
        .person_in_same_layer_or_below

      permission(:layer_and_below_read)
        .may(:show)
        .in_same_layer_or_below_if_ausbildungsmitglied

      for_self_or_manageds do
        permission(:any)
          .may(:create)
          .if_manage_attendances_in_event_or_her_own_if_application_possible
      end

      permission(:any).may(:approve).if_manage_attendances_in_event
      permission(:any).may(:reject).if_manage_attendances_in_event
    end
  end

  def if_manage_attendances_in_event
    permission_in_event?(:manage_attendances)
  end

  def if_manage_attendances_in_event_or_her_own_if_application_possible
    permission_in_event?(:manage_attendances) || her_own_if_application_possible
  end

  def person_in_same_layer_or_below
    person.nil? || permission_in_layers?(person.groups_hierarchy_ids)
  end

  def in_same_layer_or_below_if_ausbildungsmitglied
    event.is_a?(Event::Course) && contains_any?(ausbildungs_layer_ids, event_hierarchy_ids)
  end

  private

  def ausbildungs_layer_ids
    user
      .roles
      .select { |r| r.is_a?(Group::MitgliederorganisationGremium::Ausbildungsmitglied) }
      .map { |r| r.group.layer_group_id }
  end

  def event_hierarchy_ids
    event.groups.collect(&:layer_hierarchy).flatten.collect(&:id).uniq
  end
end

# frozen_string_literal: true

#  Copyright (c) 2012-2020, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

module Cevi::Event::ParticipationAbility
  extend ActiveSupport::Concern

  included do
    on(Event::Participation) do
      permission(:any).may(:become_a_leader).her_own_if_not_leader

      permission(:unconfined_below).
        may(:create_tentative).
        person_in_same_layer_or_below

      permission(:layer_and_below_read).
        may(:show).
        in_same_layer_or_below_if_ausbildungsmitglied
    end
  end

  def her_own_if_not_leader
    her_own &&
      subject.roles.all? { |r| r.is_a? Event::Course::Role::Participant } &&
      !subject.leader_interest?
  end

  def person_in_same_layer_or_below
    person.nil? || permission_in_layers?(person.groups_hierarchy_ids)
  end

  def in_same_layer_or_below_if_ausbildungsmitglied
    event.is_a?(Event::Course) && contains_any?(ausbildungs_layer_ids, event_hierarchy_ids)
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

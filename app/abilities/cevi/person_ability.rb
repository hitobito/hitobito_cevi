# frozen_string_literal: true

#  Copyright (c) 2012-2023, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

module Cevi::PersonAbility
  extend ActiveSupport::Concern

  included do
    alias_method_chain :non_restricted_in_same_layer_or_visible_below, :spender

    on(Person) do
      permission(:financials).may(:update).financials_in_same_layer

      permission(:unconfined_below).
        may(:show, :show_full, :show_details, :history, :update,
            :primary_group, :send_password_instructions, :log).
        in_same_layer_or_below

      permission(:group_full).may(:update).
        non_restricted_in_same_group_or_event_organizer
      permission(:group_and_below_full).may(:update).
        non_restricted_in_same_group_or_below_or_event_organizer
      permission(:layer_full).may(:update).
        non_restricted_in_same_layer_or_event_organizer
      permission(:layer_and_below_full).may(:update).
        non_restricted_in_same_layer_or_visible_below_or_event_organizer
      permission(:any).may(:update).herself_or_manager_or_for_leaded_events

      permission(:layer_and_below_full).may(:update_old_data).
        angestellter_or_geschaeftsfuehrung_in_same_layer_or_below

      permission(:unconfined_below).may(:change_managers).in_same_layer_or_below_except_self
      permission(:group_full).may(:change_managers).
        non_restricted_in_same_group_or_event_organizer_except_self
      permission(:group_and_below_full).may(:change_managers).
        non_restricted_in_same_group_or_below_or_event_organizer_except_self
      permission(:layer_full).may(:change_managers).
        non_restricted_in_same_layer_or_event_organizer_except_self
      permission(:layer_and_below_full).may(:change_managers).
        non_restricted_in_same_layer_or_visible_below_or_event_organizer_except_self
    end
  end

  def financials_in_same_layer
    (financial_layers_ids & spender_roles.map(&:group).map(&:layer_group_id)).present?
  end

  def non_restricted_in_same_layer_or_visible_below_with_spender
    not_only_spender_roles? && non_restricted_in_same_layer_or_visible_below_without_spender
  end

  def in_same_layer_or_below
    permission_in_layers?(subject.groups_hierarchy_ids)
  end

  def non_restricted_in_same_group_or_event_organizer
    non_restricted_in_same_group || event_organizer
  end

  def non_restricted_in_same_group_or_below_or_event_organizer
    non_restricted_in_same_group_or_below || event_organizer
  end

  def non_restricted_in_same_layer_or_event_organizer
    non_restricted_in_same_layer || event_organizer_in_layer
  end

  def non_restricted_in_same_layer_or_visible_below_or_event_organizer
    non_restricted_in_same_layer_or_visible_below || event_organizer_in_layer
  end

  def in_same_layer_or_below_except_self
    in_same_layer_or_below && !herself
  end

  def non_restricted_in_same_group_or_event_organizer_except_self
    non_restricted_in_same_group_or_event_organizer && !herself
  end

  def non_restricted_in_same_group_or_below_or_event_organizer_except_self
    non_restricted_in_same_group_or_below_or_event_organizer && !herself
  end

  def non_restricted_in_same_layer_or_event_organizer_except_self
    non_restricted_in_same_layer_or_event_organizer && !herself
  end

  def non_restricted_in_same_layer_or_visible_below_or_event_organizer_except_self
    non_restricted_in_same_layer_or_visible_below_or_event_organizer && !herself
  end

  def herself_or_manager_or_for_leaded_events
    herself || manager || event_leader
  end

  def angestellter_or_geschaeftsfuehrung_in_same_layer_or_below
    user.roles.any? { |role| angestellter_or_geschaeftsfuehrung_roles.include?(role.class) } &&
      in_same_layer_or_below
  end

  private

  def not_only_spender_roles?
    subject.roles.size != spender_roles.size
  end

  def spender_roles
    @spender_roles ||= subject.roles.select do |role|
      role.group.class.ancestors.include?(Group::Spender)
    end
  end

  def financial_layers_ids
    @financal_layer_ids ||= user.groups_with_permission(:financials).map(&:layer_group_id)
  end

  def event_organizer
    permission_in_groups?(event_group_ids)
  end

  def event_organizer_in_layer
    permission_in_layers?(event_layer_ids)
  end

  def event_leader
    (user_context.events_with_permission(:event_full) & subject.events.pluck(:id)).present?
  end

  def event_group_ids
    @event_group_ids ||= subject_event_groups.pluck(:id)
  end

  def event_layer_ids
    @event_layer_ids ||= subject_event_groups.pluck(:layer_group_id).uniq
  end

  def subject_event_groups
    Group.joins(:events).where(events: { id: subject.events.select(:id) }).distinct
  end

  def angestellter_or_geschaeftsfuehrung_roles
    [Group::MitgliederorganisationGeschaeftsstelle::Geschaeftsleiter,
     Group::MitgliederorganisationGeschaeftsstelle::Angestellter]
  end

  def manager
    contains_any?([user.id], person.managers.pluck(:id))
  end

end

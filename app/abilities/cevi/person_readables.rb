# frozen_string_literal: true

#  Copyright (c) 2012-2020, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

module Cevi::PersonReadables
  extend ActiveSupport::Concern

  include Cevi::PersonFetchables

  included do
    alias_method_chain :group_accessible_people, :spender
    alias_method_chain :layer_and_below_read_in_same_layer?, :spender

    alias_method_chain :in_same_layer_condition, :spender
    alias_method_chain :accessible_conditions, :spender

    alias_method_chain :read_permission_for_this_group?, :unconfined_below
  end

  def spender_visible?
    group_read_in_this_group? ||
      group_read_in_above_group? ||
      financial_layers_ids.include?(group.layer_group_id) ||
      unconfined_below_in_above_layer?
  end

  private

  def accessible_conditions_with_spender
    accessible_conditions_without_spender.tap do |condition|
      financials_condition(condition)
      unconfined_from_above_condition(condition)
      condition.delete(*contact_data_condition) if contact_data_visible?
    end
  end

  def group_accessible_people_with_spender
    if spender_group?
      can(:index, Person, scope_for_spender_group) { |_| true }
    else
      group_accessible_people_without_spender
    end
  end

  def scope_for_spender_group
    if spender_visible?
      group.people.only_public_data
    else
      group.people.only_public_data.merge(spender_accessible_condition)
    end
  end

  def spender_accessible_condition
    Person.visible_from_above(group).or(Person.where(*herself_condition))
  end

  def in_same_layer_condition_with_spender(condition)
    if layer_groups_same_layer.present?
      condition.or(*layer_group_query(layer_groups_same_layer.collect(&:id), without_spender_types))
    end
  end

  def layer_group_query(layer_group_ids, role_types)
    ['groups.layer_group_id IN (?) AND roles.type IN (?)',
     layer_group_ids, role_types.map(&:sti_name)]
  end

  def financials_condition(condition)
    return if financial_layers_ids.blank?

    additional_layer_ids = layer_groups_same_layer.collect(&:id) & financial_layers_ids
    query = layer_group_query(additional_layer_ids, Role.all_types)
    condition.or(*query)
  end

  def read_permission_for_this_group_with_unconfined_below?
    read_permission_for_this_group_without_unconfined_below? ||
    unconfined_below_in_above_layer?
  end

  def unconfined_below_in_above_layer?
    layers_unconfined_below.present? &&
    (layers_unconfined_below & group.layer_hierarchy.collect(&:id)).present?
  end

  def layers_unconfined_below
    @layers_unconfined_below ||=
      user_context.layer_ids(user.groups_with_permission(:unconfined_below).to_a)
  end

  def without_spender_types
    Role.all_types.reject { |type| type.name =~ /Spender$/ }
  end

  def layer_and_below_read_in_same_layer_with_spender?
    spender_group? ? false : layer_and_below_read_in_same_layer_without_spender?
  end

  def spender_group?
    group.is_a?(Group::Spender)
  end

  def financial_layers_ids
    @financial_layers_ids ||= user.groups_with_permission(:financials).map(&:layer_group_id)
  end

end

# frozen_string_literal: true

#  Copyright (c) 2012-2020, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

module Cevi::PersonReadables
  def spender_visible?
    service_token_with_show_donors? ||
      group_read_in_this_group? ||
      group_read_in_above_group? ||
      financial_layers_ids.include?(group.layer_group_id) ||
      see_invisible_from_above_in_above_layer?
  end

  private

  def accessible_conditions
    super.tap do |condition|
      financials_condition(condition)
      condition.delete(*contact_data_condition) if contact_data_visible?
    end
  end

  def group_accessible_people
    if spender_group?
      can(:index, Person, scope_for_spender_group) { |_| true }
    else
      super
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

  def in_same_layer_condition(condition)
    if layer_groups_same_layer.present?
      condition.or(*layer_group_query(layer_groups_same_layer.collect(&:id), without_spender_types))
    end
  end

  def layer_group_query(layer_group_ids, role_types)
    ["groups.layer_group_id IN (?) AND roles.type IN (?)",
      layer_group_ids, role_types.map(&:sti_name)]
  end

  def financials_condition(condition)
    return unless financial_layers_ids.present? || service_token_with_show_donors?

    additional_layer_ids = layer_groups_same_layer.collect(&:id) & financial_layers_ids
    additional_layer_ids << service_token_layer_id if service_token_with_show_donors?
    query = layer_group_query(additional_layer_ids, Role.all_types)
    condition.or(*query)
  end

  def without_spender_types
    Role.all_types.reject { |type| type.name =~ /Spender$/ }
  end

  def layer_and_below_read_in_same_layer?
    spender_group? ? false : super
  end

  def spender_group?
    group.is_a?(Group::Spender)
  end

  def financial_layers_ids
    @financial_layers_ids ||= user.groups_with_permission(:financials).map(&:layer_group_id)
  end

  def service_token_with_show_donors?
    return false unless service_token

    service_token.show_donors?
  end

  def service_token_layer_id
    return unless service_token

    service_token.layer_group_id
  end

  def service_token
    @service_token ||= user.instance_variable_get(:@service_token)
  end
end

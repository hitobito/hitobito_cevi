# encoding: utf-8

#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

module Cevi::PersonAccessibles
  extend ActiveSupport::Concern

  included do
    alias_method_chain :group_accessible_people, :spender
    alias_method_chain :layer_and_below_read_in_same_layer?, :spender

    alias_method_chain :in_same_layer_condition, :spender
    alias_method_chain :accessible_conditions, :spender
  end

  private

  def accessible_conditions_with_spender
    return accessible_conditions_without_spender unless financial_layers_ids.present?

    condition = accessible_conditions_without_spender
    additional_layer_ids = read_layer_groups.collect(&:id) & financial_layers_ids
    query = layer_group_query(additional_layer_ids, Role.all_types)
    condition.or(*query)
    condition
  end

  def group_accessible_people_with_spender(user)
    return group_accessible_people_without_spender(user) unless spender_group?

    can(:index, Person, scope_for_spender_group)
  end

  def scope_for_spender_group
    if group_read_in_this_group? || financial_layers_ids.include?(group.layer_group_id)
      group.people.only_public_data { |_| true }
    else
      group.people.only_public_data.visible_from_above(group) { |_| true }
    end
  end

  def in_same_layer_condition_with_spender(layer_groups)
    layer_group_query(layer_groups.collect(&:id), without_spender_types)
  end

  def layer_group_query(layer_group_ids, role_types)
    ['groups.layer_group_id IN (?) AND roles.type IN (?)',
     layer_group_ids, role_types.map(&:sti_name)]
  end

  def without_spender_types
    Role.all_types.reject { |type| type.name =~ /Spender$/ }
  end

  def layer_and_below_read_in_same_layer_with_spender?
    spender_group? ? false : layer_and_below_read_in_same_layer_without_spender?
  end

  def spender_group?
    @spender_group ||= group.class.ancestors.include?(Group::Spender)
  end

  def financial_layers_ids
    @financal_layer_ids ||= user.groups_with_permission(:financials).map(&:layer_group_id)
  end

end

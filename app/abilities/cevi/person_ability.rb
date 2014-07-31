# encoding: utf-8

#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

module Cevi::PersonAbility
  extend ActiveSupport::Concern

  included do
    alias_method_chain :non_restricted_in_same_layer_or_visible_below, :spender

    on(Person) do
      permission(:financials).may(:update).financials_in_same_layer
    end
  end

  def financials_in_same_layer
    (financial_layers_ids & spender_roles.map(&:group).map(&:layer_group_id)).present?
  end

  def non_restricted_in_same_layer_or_visible_below_with_spender
    not_only_spender_roles? && non_restricted_in_same_layer_or_visible_below_without_spender
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

end

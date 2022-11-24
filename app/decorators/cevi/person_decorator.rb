# frozen_string_literal: true

#  Copyright (c) 2012-2020, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

module Cevi::PersonDecorator
  extend ActiveSupport::Concern

  included do
    alias_method_chain :roles_grouped, :filtered_spender_roles
    alias_method_chain :filtered_roles, :spenders_removed
  end

  private

  def filtered_roles_with_spenders_removed(group, multiple_groups = false)
    filtered_roles_without_spenders_removed(group).reject do |role|
      role.is_a?(::Group::MitgliederorganisationSpender::Spender) &&
        !(role.person_id == current_user&.id || current_service_token&.show_donors?)
    end
  end

  def roles_grouped_with_filtered_spender_roles
    roles_grouped_without_filtered_spender_roles.collect do |group, roles|
      next [group, roles] if !group.is_a?(Group::Spender) || spender_visible?(group)

      visible_roles = roles.select(&:visible_from_above?)
      [group, visible_roles] if visible_roles.present?
    end.compact.to_h
  end

  def spender_visible?(group)
    PersonReadables.new(h.current_user, group).spender_visible?
  end

  def spender_roles
    @spender_roles ||= subject.roles.select do |role|
      role.group.class.ancestors.include?(Group::Spender)
    end
  end

end

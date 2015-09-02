# encoding: utf-8

#  Copyright (c) 2012-2015, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

module Cevi::AbilityDsl::Base
  extend ActiveSupport::Concern

  included do
    alias_method_chain :user_layers, :unconfined_below
    alias_method_chain :user_groups, :unconfined_below
  end

  def user_groups_with_unconfined_below
    @user_groups ||=
        case permission
        when :unconfined_below
          user.groups_with_permission(:unconfined_below).to_a.collect(&:id)
        else
          user_groups_without_unconfined_below
        end
  end

  def user_layers_with_unconfined_below
    @user_layers ||=
        case permission
        when :unconfined_below
          user_context.layer_ids(user.groups_with_permission(:unconfined_below).to_a)
        else
          user_layers_without_unconfined_below
        end
  end
end

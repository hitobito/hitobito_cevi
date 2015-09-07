# encoding: utf-8

#  Copyright (c) 2012-2015, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

module Cevi::AbilityDsl::Base
  extend ActiveSupport::Concern

  included do
    alias_method_chain :user_layer_ids, :unconfined_below
    alias_method_chain :user_group_ids, :unconfined_below
  end

  def user_group_ids_with_unconfined_below
    case permission
    when :unconfined_below
      user.groups_with_permission(:unconfined_below).to_a.collect(&:id)
    else
      user_group_ids_without_unconfined_below
    end
  end

  def user_layer_ids_with_unconfined_below
    case permission
    when :unconfined_below
      user_context.layer_ids(user.groups_with_permission(:unconfined_below).to_a)
    else
      user_layer_ids_without_unconfined_below
    end
  end
end

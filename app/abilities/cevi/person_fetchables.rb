# encoding: utf-8

#  Copyright (c) 2012-2015, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

module Cevi::PersonFetchables

  private

  def unconfined_from_above_condition(condition)
    return if layer_groups_unconfined_below.blank?

    unconfined_from_above_groups = OrCondition.new
    collapse_groups_to_highest(layer_groups_unconfined_below) do |layer_group|
      unconfined_from_above_groups.or('groups.lft >= ? AND groups.rgt <= ?',
                                      layer_group.left,
                                      layer_group.rgt)
    end

    condition.or(*unconfined_from_above_groups.to_a)
  end

  def layer_groups_unconfined_below
    @layer_groups_unconfined_below ||= layer_groups_with_permissions(:unconfined_below)
  end

end

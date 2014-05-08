# encoding: utf-8

#  Copyright (c) 2012-2014, Pfadibewegung Schweiz. This file is part of
#  hitobito_pbs and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_pbs.

module Cevi::GroupAbility
  extend ActiveSupport::Concern

  included do
    on(Group) do
      permission(:layer_full).
        may(:evaluate_census).
        in_same_layer_or_below

      permission(:layer_full).
        may(:show_population, :create_member_counts).
        in_same_layer_or_below

      permission(:layer_full).
        may(:remind_census, :update_member_counts, :delete_member_counts).
        in_same_layer_or_below
    end

  end
end

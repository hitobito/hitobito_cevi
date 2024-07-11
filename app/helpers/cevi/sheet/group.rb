#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

module Cevi::Sheet::Group
  extend ActiveSupport::Concern

  included do
    tabs.insert(
      -2,
      Sheet::Tab.new(:tab_population_label,
        :population_group_path,
        if: lambda do |view, group|
          MemberCounter::TOP_LEVEL.any? do |group_type|
            group.is_a?(group_type)
          end && view.can?(:show_population, group)
        end),
      Sheet::Tab.new("groups.tabs.statistic",
        :census_evaluation_path,
        alt: [:censuses_tab_path, :group_member_counts_path],
        if: lambda do |view, group|
          group.census? && view.can?(:evaluate_census, group)
        end)
    )
  end
end

# encoding: utf-8

#  Copyright (c) 2014, Pfadibewegung Schweiz. This file is part of
#  hitobito_pbs and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_pbs.

module Cevi::Sheet::Group
  extend ActiveSupport::Concern

  included do
    tabs.insert(
      -2,
      Sheet::Tab.new(:tab_population_label,
                     :population_group_path,
                     if: lambda { |view, group|
                       group.population? && view.can?(:show_population, group)
                     }),

      Sheet::Tab.new('groups.tabs.statistic',
                     :census_dachverband_group_path,
                     alt: [:censuses_tab_path, :group_member_counts_path],
                     if: lambda { |view, group|
                       group.census? && view.can?(:evaluate_census, group)
                     }))
  end

end

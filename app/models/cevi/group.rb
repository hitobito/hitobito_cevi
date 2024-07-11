#  Copyright (c) 2023, Cevi.DB Steuergruppe. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

module Cevi::Group
  extend ActiveSupport::Concern

  included do
    class_attribute :contact_group_type

    self.used_attributes += [:founding_date]

    root_types Group::Dachverband
  end

  def census?
    respond_to?(:census_total)
  end

  def population_approveable?
    current_census = Census.current
    current_census && !MemberCounter.new(current_census.year, self).exists?
  end
end

# encoding: utf-8

#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

# == Schema Information
#
# Table name: groups
#
#  id             :integer          not null, primary key
#  parent_id      :integer
#  lft            :integer
#  rgt            :integer
#  name           :string(255)      not null
#  short_name     :string(31)
#  type           :string(255)      not null
#  email          :string(255)
#  address        :string(1024)
#  zip_code       :integer
#  town           :string(255)
#  country        :string(255)
#  contact_id     :integer
#  created_at     :datetime
#  updated_at     :datetime
#  deleted_at     :datetime
#  layer_group_id :integer
#  creator_id     :integer
#  updater_id     :integer
#  deleter_id     :integer
#

module Cevi::Group
  extend ActiveSupport::Concern

  included do
    root_types Group::Dachverband
    class_attribute :population
  end

  def census?
    respond_to?(:census_total)
  end

  def population?
    respond_to?(:population) && self.population
  end

  # def census_groups(_year)
  #   []
  # end

  # def census_total(year)
  #   MemberCount.total_for_abteilung(year, self)
  # end

  # def census_details(year)
  #   MemberCount.details_for_abteilung(year, self)
  # end

  def population_approveable?
    current_census = Census.current
    current_census && !MemberCounter.new(current_census.year, self).exists?
  end

end

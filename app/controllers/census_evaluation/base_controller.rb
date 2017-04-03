# encoding: utf-8

#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

class CensusEvaluation::BaseController < ApplicationController

  include YearBasedPaging

  class_attribute :sub_group_type

  before_action :authorize

  decorates :group, :sub_groups

  def index
    @sub_groups = evaluation.sub_groups
    @group_counts = evaluation.counts_by_sub_group
    @total = evaluation.total || empty_count_for_current_census
    @details = evaluation.details
  end

  private

  def csv_export(conditions = {})
    counts = MemberCount.
      includes(:group, :mitgliederorganisation).
      where(conditions.merge(year: year))

    Export::Tabular::MemberCount.csv(counts)
  end

  def evaluation
    @evaluation ||= CensusEvaluation.new(year, group, sub_group_type)
  end

  def empty_count_for_current_census
    year == Census.current.try(:year) ? MemberCount.new : nil
  end

  def group
    @group ||= Group.find(params[:id])
  end

  def default_year
    @default_year ||= Census.current.try(:year) || current_year
  end

  def current_year
    @current_year ||= Time.zone.today.year
  end

  def year_range
    @year_range ||= (year - 3)..(year + 1)
  end

  def authorize
    authorize!(:evaluate_census, group)
  end
end

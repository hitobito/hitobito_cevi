# encoding: utf-8

#  Copyright (c) 2012-2014, Pfadibewegung Schweiz. This file is part of
#  hitobito_pbs and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_pbs.

class MemberCountsController < ApplicationController

  decorates :group

  def create
    authorize!(:create_member_counts, group)

    year = MemberCounter.create_counts_for(group)
    if year
      total = MemberCount.total_for_group(year, group).try(:total) || 0
      flash[:notice] = translate('.created_data_for_year', total: total, year: year)
    end

    year ||= Date.today.year
    redirect_to census_group_group_path(group, year: year)
  end

  def edit
    authorize!(:update_member_counts, group)
    member_counts
  end

  def update
    authorize!(:update_member_counts, group)
    counts = []
    if params[:member_count]
      counts = member_counts.update(params[:member_count].keys, params[:member_count].values)
    end

    @additional_member_counts = create_additional_member_counts
    with_errors = (counts + @additional_member_counts).select { |c| c.errors.present? }

    if with_errors.blank?
      flash[:notice] = "Die Mitgliederzahlen für #{year} wurden erfolgreich gespeichert"
      redirect_to census_group_group_path(group, year: year)
    else
      messages = with_errors.collect do |e|
        "#{e.born_in}: #{e.errors.full_messages.join(', ')}"
      end.join('; ')
      flash.now[:alert] = 'Nicht alle Jahrgänge konnten gespeichert werden. ' \
                          "Bitte überprüfen Sie Ihre Angaben. (#{messages})"
      render 'edit'
    end
  end

  def destroy
    authorize!(:delete_member_counts, group)

    member_counts.destroy_all
    redirect_to census_group_group_path(group, year: year),
                notice: translate('.deleted_data_for_year', year: year)
  end

  private

  def member_counts
    @member_counts ||= group.member_counts.where(year: year).order(:born_in)
  end

  def create_additional_member_counts
    additionals = params.permit(additional_member_counts:
                                [:born_in, :person_f, :person_m])[:additional_member_counts] || []
    additionals.map do |attrs|
      @group.member_counts.create(attrs.merge(mitgliederorganisation: group.mitgliederorganisation,
                                              year: year))
    end
  end

  def group
    @group ||= Group.find(params[:group_id])
  end

  def year
    @year ||= Census.current.try(:year) ||
              fail(ActiveRecord::RecordNotFound, 'No current census found')
  end

  def permitted_params
    params.require(:member_count).permit(MemberCount::COUNT_COLUMNS)
  end


end

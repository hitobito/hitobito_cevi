#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

class MemberCountsController < ApplicationController
  decorates :group

  def create
    authorize!(:create_member_counts, group)

    year = MemberCounter.create_counts_for(group)
    if year
      total = MemberCount.total_for_group(year, group).try(:total) || 0
      flash[:notice] = translate(".created_data_for_year", total: total, year: year)
    end

    year ||= Time.zone.today.year
    redirect_to census_group_group_path(group, year: year)
  end

  def edit
    authorize!(:update_member_counts, group)
    year
  end

  def update
    authorize!(:update_member_counts, group)
    year # fail fast without a current census, before touching any params

    if group.update(permitted_params)
      redirect_to census_group_group_path(group, year: year),
        notice: "Die Mitgliederzahlen für #{year} wurden erfolgreich gespeichert"
    else
      flash.now[:alert] = faulty_counts_message
      render "edit"
    end
  end

  def destroy
    authorize!(:delete_member_counts, group)

    group.current_member_counts.destroy_all
    redirect_to census_group_group_path(group, year: year),
      notice: translate(".deleted_data_for_year", year: year)
  end

  private

  def faulty_counts_message
    messages = group.current_member_counts.select { |c| c.errors.present? }.collect do |c|
      "#{c.born_in || "unbekannt"}: #{c.errors.full_messages.join(", ")}"
    end

    "Nicht alle Jahrgänge konnten gespeichert werden. " \
    "Bitte überprüfen Sie Ihre Angaben. (#{messages.join("; ")})"
  end

  def group
    @group ||= Group.find(params[:group_id])
  end

  def year
    @year ||= Census.current.try(:year) ||
      fail(ActiveRecord::RecordNotFound, "No current census found")
  end

  def permitted_params
    params.require(:group)
      .permit(current_member_counts_attributes: [:id, :born_in, :person_f, :person_m])
  end
end

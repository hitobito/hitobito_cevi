# encoding: utf-8

#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

class CensusesController < CrudController

  self.permitted_attrs = [:year, :start_at, :finish_at]

  before_action :group

  decorates :group

  def create
    super(location: census_dachverband_group_path(Group.root))
  end

  private

  def group
    @group ||= Group.root
  end

end

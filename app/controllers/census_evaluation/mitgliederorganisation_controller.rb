# encoding: utf-8

#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

class CensusEvaluation::MitgliederorganisationController < CensusEvaluation::BaseController

  self.sub_group_type = MemberCounter::TOP_LEVEL

  def index
    super

    respond_to do |format|
      format.html
      format.csv { send_data(csv_export(mitgliederorganisation: group), type: :csv) }
    end
  end
end

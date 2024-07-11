# frozen_string_literal: true

#  Copyright (c) 2020, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

module Cevi::Person::LogController
  def version_conditions
    return super if Settings.people.visible_log_months.blank?

    start_timestamp = Settings.people.visible_log_months.months.ago
    finish_timestamp = DateTime.current

    super.merge({created_at: (start_timestamp..finish_timestamp)})
  end
end

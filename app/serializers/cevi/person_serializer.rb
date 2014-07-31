# encoding: utf-8

#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

module Cevi::PersonSerializer
  extend ActiveSupport::Concern

  included do
    extension(:details) do |_|
      map_properties :title,
                     :profession,
                     :j_s_number,
                     :joined,
                     :ahv_number,
                     :ahv_number_old,
                     :salutation_parents,
                     :name_parents,
                     :member_card_number,
                     :nationality,
                     :salutation,
                     :correspondence_language,
                     :canton,
                     :confession
    end
  end

end
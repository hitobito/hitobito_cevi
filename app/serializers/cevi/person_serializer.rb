#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

module Cevi::PersonSerializer
  extend ActiveSupport::Concern

  included do
    extension(:public) do |_|
      map_properties :salutation_parents, :name_parents

      entity :ortsgruppe, item.ortsgruppe, GroupLinkSerializer
      group_template_link "people.ortsgruppe"
    end

    extension(:details) do |_|
      map_properties :title,
        :profession,
        :joined,
        :ahv_number_old,
        :member_card_number,
        :nationality,
        :salutation,
        :correspondence_language,
        :canton,
        :confession
    end
  end
end

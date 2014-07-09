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
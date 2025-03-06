#  Copyright (c) 2012-2015, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

module Cevi::PeopleController
  extend ActiveSupport::Concern

  included do
    self.permitted_attrs += [:title, :profession, :j_s_number, :joined, :nationality,
      :salutation_parents, :name_parents, :member_card_number, :salutation,
      :canton, :confession, :correspondence_language, :ortsgruppe_id]

    alias_method_chain :permitted_attrs, :old_data
  end

  private

  def permitted_attrs_with_old_data
    attrs = permitted_attrs_without_old_data
    if can?(:update_old_data, entry)
      attrs += [:old_data]
    end
    attrs
  end
end

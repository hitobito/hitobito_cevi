-#  Copyright (c) 2012-2024, CEVI Regionalverband ZH-SH-GL. This file is part of
-#  hitobito_cevi and licensed under the Affero General Public License version 3
-#  or later. See the COPYING file at the top-level directory or at
-#  https://github.com/hitobito/hitobito_cevi.

module Cevi::EventParticipationsHelper
  def event_participation_table_options(t)
    t.col(Person.human_attribute_name(:ortsgruppe)) do |p|
      format_ortsgruppe(p)
    end
    if can?(:update, @event)
      t.attr(:internal_comment)
      t.sortable_attr(:payed)
    end
  end
end
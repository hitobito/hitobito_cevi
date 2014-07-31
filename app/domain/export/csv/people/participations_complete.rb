# encoding: utf-8

#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

module Export::Csv::People
  class ParticipationsComplete < ParticipationsFull

    self.row_class = Export::Csv::People::ParticipationRowComplete

    def build_attribute_labels
      super.merge(custom_labels)
    end

    private

    def custom_labels
      { payed: ::Event::Participation.human_attribute_name(:payed),
        internal_comment: ::Event::Participation.human_attribute_name(:internal_comment) }
    end
  end
end

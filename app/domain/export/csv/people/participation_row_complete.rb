# encoding: utf-8

#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

module Export::Csv::People
  class ParticipationRowComplete < ParticipationRow
    include EventParticipationsCeviHelper
    include ActionView::Helpers::TranslationHelper

    def payed
      format_payed(@participation)
    end

    def internal_comment
      @participation.internal_comment
    end
  end
end

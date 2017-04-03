# encoding: utf-8

#  Copyright (c) 2012-2017, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

module Export::Tabular::People
  class ParticipationRowComplete < ParticipationRow

    def payed
      @participation.payed? ? I18n.t('global.yes') : I18n.t('global.no')
    end

    def internal_comment
      @participation.internal_comment
    end

  end
end

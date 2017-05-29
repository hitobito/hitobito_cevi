# encoding: utf-8

#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

module EventParticipationsCeviHelper

  def format_ortsgruppe(participation)
    participation.person.ortsgruppe_label
  end

  def format_event_participation_payed(participation)
    participation.payed? ? t('global.yes') : t('global.no')
  end

end

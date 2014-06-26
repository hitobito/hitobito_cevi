module EventParticipationsHelper

  def format_payed(participation)
    participation.payed? ? t('global.yes') : t('global.no')
  end

end

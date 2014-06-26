module Export::Csv::People
  class ParticipationRowComplete < ParticipationRow
    include EventParticipationsHelper
    include ActionView::Helpers::TranslationHelper

    def payed
      format_payed(@participation)
    end

    def internal_comment
      @participation.internal_comment
    end
  end
end

# frozen_string_literal: true

#  Copyright (c) 2020, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

module Cevi::Event::ParticipationMailer
  CONTENT_LEADER_INTEREST = 'event_participant_leader_interest'

  def leader_interest(participation, recipient)
    @participation = participation
    @recipient     = recipient

    custom_content_mail(recipient,
                        CONTENT_LEADER_INTEREST,
                        values_for_placeholders(CONTENT_LEADER_INTEREST))
  end

  private

  def placeholder_course_name
    event.name
  end

  def placeholder_recipient_name
    @recipient.greeting_name
  end
end

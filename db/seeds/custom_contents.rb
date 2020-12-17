# frozen_string_literal: true

#  Copyright (c) 2020, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

# CustomContent.seed_once(:key,
#   { key: Event::ParticipationMailer::CONTENT_LEADER_INTEREST,
#     placeholders_required: 'participant-name, application-url',
#     placeholders_optional: 'course-name, recipient-name' },
# )

# leader_interest_id = CustomContent.get(Event::ParticipationMailer::CONTENT_LEADER_INTEREST).id

# CustomContent::Translation.seed_once(:custom_content_id, :locale,
#   {
#     custom_content_id: leader_interest_id,
#     locale: 'de',
#     label: 'Hinweis auf Interesse an Mitarbeit im Leiterteam',
#     subject: "Interesse an Mitarbeit im Leiterteam bekundet",
#     body: "Hallo {recipient-name}<br/><br/>" \
#           "{participant-name} hat Interesse an der Mitarbeit im Leiterteam des Kurses {course-name} bekundet.<br/>" \
#           "Die Anmeldung ist via {application-url} erreichbar.<br/><br/>"
#   },
# )

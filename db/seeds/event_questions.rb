# frozen_string_literal: true

#  Copyright (c) 2020, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

role_names = Event::Course.role_types
                          .reject(&:restricted?)
                          .map { |role| I18n.t(role.name.underscore, scope: 'activerecord.models', count: 1) }
                          .map { |role_name| role_name.gsub(',', '') }

# if we want to change the wording, we can do this with a
# data-migration alongside the same update here.
Event::Question.seed(:event_id, :question,
  {
    event_id: nil, # global question
    question: 'Ich habe Interesse an einer Mitarbeit im Leiterteam in einer der folgenden Rollen',
    choices: role_names.join(','),
    multiple_choices: true
  },
)

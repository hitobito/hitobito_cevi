# frozen_string_literal: true

#  Copyright (c) 2020-2021, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

# if we want to change the wording of the question, we can do this with a
# data-migration alongside the same update here.

Event::Question.seed_global({
    event_id: nil, # global question
    event_type: Event::Course.sti_name, # only for courses
    disclosure: :optional,
    question: 'Ich habe Interesse an einer Mitarbeit im Leiterteam in einer der folgenden Rollen',
    choices: ['Gruppenleiter/-in', 'Küche', 'andere Funktion'].join(','),
    customize_derived: true,
    multiple_choices: true
  })

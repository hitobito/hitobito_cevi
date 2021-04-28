# frozen_string_literal: true

#  Copyright (c) 2020-2021, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

# if we want to change the wording of the question, we can do this with a
# data-migration alongside the same update here. choices and other attributes
# are updated on every db:seed
[
  {
    event_id: nil, # global question
    question: 'Ich habe Interesse an einer Mitarbeit im Leiterteam in einer der folgenden Rollen',
    choices: ['Gruppenleiter/-in', 'Küche', 'andere Funktion'].join(','),
    multiple_choices: true
  },
].each do |attrs|
  eq = Event::Question.find_or_initialize_by(
    event_id: attrs.delete(:event_id),
    question: attrs.delete(:question),
  )
  eq.attributes = attrs

  if eq.save
    puts "<Event::Question '#{eq.question}' -- '#{eq.choices}'> saved."
  else
    raise <<~ERRORMESSAGE
      Error while saving: <Event::Question '#{eq.question}' -- '#{eq.choices}'>.

      #{eq.errors.full_messages.to_sentence}
    ERRORMESSAGE
  end
end

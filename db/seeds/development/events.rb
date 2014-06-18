# encoding: utf-8

#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

require Rails.root.join('db', 'seeds', 'support', 'event_seeder')

srand(42)

@seeder = EventSeeder.new

# Base events
layer_types = Group.all_types.select(&:layer).collect(&:sti_name)
Group.where(type: layer_types).pluck(:id).each do |group_id|
  10.times do
    @seeder.seed_event(group_id, :base)
  end
end


def seed_course(values)
  values.merge!({
    priorization: true,
    requires_approval: true
  })
  event = Event::Course.seed(:name, values).first

  @seeder.seed_dates(event, values[:application_opening_at] + 90.days)
  @seeder.seed_questions(event)
  @seeder.seed_leaders(event)
  @seeder.seed_participants(event)

  event
end


# Courses
zhshgl = Group::Mitgliederorganisation.where(name: 'Cevi Regionalverband ZH-SH-GL').first
glk3_kind = Event::Kind.find(5)
llm_kind = Event::Kind.find(6)

glk3 = seed_course({
  group_ids: [zhshgl.id],
  kind_id: glk3_kind.id,
  name: 'GLK3 Fa',
  cost: '295.–',
  description: 'Im GLK3 lernst du neue altersangepasste Programmformen kennen. Selbständigkeit trainieren, gruppendynamische Prozesse erkennen und Verhalten der heranwachsenden Teenies studieren gehören dazu. Du setzst dich mit Fragen zu deinem Glauben auseinander und lernst einen Input zu gestalten. Inspiriert mit unzähligen Ideen sorgst du im Cevi-Alltag für neuen Schwung.',
  location: 'Hischwil, Wald ZH',
  application_opening_at: Date.new(2015,2,2),
  application_closing_at: Date.new(2015,3,2)
})

llm = seed_course({
  group_ids: [zhshgl.id],
  kind_id: llm_kind.id,
  name: 'LLM b',
  cost: '295.–',
  description: 'Eigne dir das Know-How an, ein J+S-Lager im Sportfach Lagersport / Trekking selbständig zu organisieren und durchzuführen! Du lernst, welches die Aufgaben, Pflichten und Verantwortungen eines Lagerleiters / einer Lagerleiterin sind. Natürlich kommen Spiel und Sport sowie das Gemeinschaftsleben mit anderen Leitern und Leiterinnen nicht zu kurz.',
  location: 'Greifensee ZH / Lachen SZ',
  application_opening_at: Date.new(2014,6,7),
  application_closing_at: Date.new(2014,7,7)
})

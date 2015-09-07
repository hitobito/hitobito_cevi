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
  3.times do
    @seeder.seed_event(group_id, :base)
  end
end

@seeder.course_group_ids.each do |group_id|
  5.times do
    @seeder.seed_event(group_id, :course)
  end
end

Event::Participation.update_all(state: 'assigned', active: true)

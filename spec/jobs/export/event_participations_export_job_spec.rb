# encoding: utf-8

#  Copyright (c) 2017, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

require 'spec_helper'

describe Export::EventParticipationsExportJob do

  subject { Export::EventParticipationsExportJob.new(format,
                                                     user.id,
                                                     course.id,
                                                     event_participation_filter,
                                                     params) }

  let(:group) { groups(:dachverband) }
  let(:user) { people(:bulei) }
  let(:person) { people(:bulei) }
  let(:course) do
    course = Fabricate(:cevi_course, groups: [group], priorization: true)
    course.questions << Fabricate(:event_question, event: course)
    course.questions << Fabricate(:event_question, event: course)
    course.dates << Fabricate(:event_date, event: course)
    course
  end
  let(:event_role)    { Fabricate(:event_role, type: Event::Role::Leader.sti_name) }
  let(:participation) { Fabricate(:event_participation, event: course, person: person, roles: [event_role]) }
  let(:event_participation_filter) { Event::ParticipationFilter.new(course, user, params) }

  before do
    SeedFu.quiet = true
    SeedFu.seed [Rails.root.join('db', 'seeds')]
    participation
  end

  context 'exports full csv files' do
    let(:format) { :csv }
    let(:params) { { details: false } }

    it 'and sends it via mail' do
      expect do
        subject.perform
      end.to change { ActionMailer::Base.deliveries.size }.by 1

      expect(last_email.subject).to eq('Export der Event-Teilnehmer')

      lines = last_email.attachments.first.body.to_s.split("\n")
      expect(lines.size).to eq(2)
      expect(lines[0]).to match(/^Vorname;Nachname/)
      expect(lines[0].split(';').count).to match(17)
    end
  end

  context 'exports full csv files' do
    let(:format) { :csv }
    let(:params) { { details: true } }

    it 'and sends it via mail' do
      expect do
        subject.perform
      end.to change { ActionMailer::Base.deliveries.size }.by 1

      expect(last_email.subject).to eq('Export der Event-Teilnehmer')

      lines = last_email.attachments.first.body.to_s.split("\n")
      expect(lines.size).to eq(2)
      expect(lines[0]).to match(/^Vorname;Nachname;.+;Bezahlt;Interne Bemerkung$/)
      expect(lines[0].split(';').count).to match(38)
    end
  end
end

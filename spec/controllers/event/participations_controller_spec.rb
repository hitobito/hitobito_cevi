# encoding: utf-8

#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

require 'spec_helper'

describe Event::ParticipationsController do

  let(:group) { groups(:dachverband) }

  let(:course) do
    course = Fabricate(:cevi_course, groups: [group], priorization: true)
    course.questions << Fabricate(:event_question, event: course)
    course.questions << Fabricate(:event_question, event: course)
    course.dates << Fabricate(:event_date, event: course)
    course
  end

  let(:other_course) do
    other = Fabricate(:cevi_course, groups: [group], kind: course.kind)
    other.dates << Fabricate(:event_date, event: other, start_at: course.dates.first.start_at)
    other
  end

  let(:participation) do
    p = Fabricate(:event_participation, event: course, application: Fabricate(:jubla_event_application, priority_2: Fabricate(:cevi_course, kind: course.kind)))
    p.answers.create!(question_id: course.questions[0].id, answer: 'juhu')
    p.answers.create!(question_id: course.questions[1].id, answer: 'blabla')
    p
  end


  let(:user) { people(:bulei) }

  before { sign_in(user); other_course }

  context 'GET index' do

    before do
      @leader, @participant = *create(Event::Role::Leader, course.participant_type)
    end

    it 'lists only leader_group' do
      get :index, group_id: group.id, event_id: course.id, filter: :teamers
      assigns(:participations).should eq [@leader]
    end

    it 'lists only participant_group' do
      get :index, group_id: group.id, event_id: course.id, filter: :participants
      assigns(:participations).should eq [@participant]
    end

    def create(*roles)
      roles.map do |role_class|
        role = Fabricate(:event_role, type: role_class.name)
        Fabricate(:event_participation, event: course, roles: [role], active: true)
      end
    end
  end

end

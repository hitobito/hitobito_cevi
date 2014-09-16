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


  context 'GET index' do
    before do
      sign_in(user)
      other_course

      @leader, @participant = *create(Event::Role::Leader, course.participant_types.first)
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


  context 'custom attributes' do
    let(:csv) { CSV.parse(response.body, headers: true, col_sep: ';') }
    let(:custom_attrs) { { internal_comment: 'test', payed: '1' } }
    let(:participation) { Fabricate(:event_participation, event: course, person: person) }

    before do
      course.update_attribute(:state, :application_open)
      sign_in(person)
    end

    def activate_participation
      participation.roles << Fabricate(:event_role, type: course.participant_types.first.name)
      participation.update_attributes(active: true, internal_comment: 'test', payed: true)
    end


    context 'with update permission' do
      let(:person) { people(:bulei) }

      it "updates attributes on create" do
        post :create, group_id: group.id, event_id: course.id, event_participation: custom_attrs
        assigns(:participation).should be_payed
        assigns(:participation).internal_comment.should eq 'test'
      end

      it "updates attributes on update" do
        patch :update, group_id: group.id, event_id: course.id, id: participation.id, event_participation: custom_attrs
        participation.reload.should be_payed
        participation.reload.internal_comment.should eq 'test'
      end

      it "includes attributes in csv" do
        activate_participation
        get :index, group_id: group.id, event_id: course.id, filter: :participants, format: :csv

        csv['Bezahlt'].should eq %w(ja)
        csv['Interne Bemerkung'].should eq %w(test)
      end

      context 'rendered pages' do
        render_views
        before { activate_participation }

        it "includes columns in index page" do
          get :index, group_id: group.id, event_id: course.id, filter: :participants
        end

        it "includes attributes on show" do
          get :show, group_id: group.id, event_id: course.id, id: participation.id
        end

        it "includes attributes on edit" do
          get :edit, group_id: group.id, event_id: course.id, id: participation.id
        end

        after do
          html = Capybara::Node::Simple.new(response.body)
          html.should have_content 'Bezahlt'
          html.should have_content 'Interne Bemerkung'
        end
      end

    end


    context 'without update permission' do
      let(:person) { people(:al_altst) }

      it "ignores attributes on create" do
        post :create, group_id: group.id, event_id: course.id, event_participation: custom_attrs
        assigns(:participation).should_not be_payed
        assigns(:participation).internal_comment.should be_blank
      end

      it "not allowed to update" do
        expect do
          patch :update, group_id: group.id, event_id: course.id, id: participation.id, event_participation: custom_attrs
        end.to raise_error CanCan::AccessDenied
      end

      it "does not include attributes in csv" do
        activate_participation
        get :index, group_id: group.id, event_id: course.id, filter: :participants, format: :csv

        csv.headers.should_not include 'Bezahlt'
        csv.headers.should_not include 'Interne Bemerkung'
      end

      context 'rendered pages' do
        render_views
        before { activate_participation }

        it "does not include columns on index page" do
          get :index, group_id: group.id, event_id: course.id, filter: :participants
        end

        it "does not include attributes on show" do
          get :show, group_id: group.id, event_id: course.id, id: participation.id
        end

        it "does not render edit page" do
          expect do
            get :edit, group_id: group.id, event_id: course.id, id: participation.id
          end.to raise_error CanCan::AccessDenied
        end

        after do
          html = Capybara::Node::Simple.new(response.body)
          html.should_not have_content 'Bezahlt'
          html.should_not have_content 'Interne Bemerkung'
        end
      end

    end
  end

end

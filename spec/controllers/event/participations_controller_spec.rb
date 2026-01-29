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

  let(:user) { people(:bulei) }


  context 'GET index' do
    before do
      sign_in(user)
      other_course

      @leader, @participant = *create(Event::Role::Leader, course.participant_types.first)
    end

    it 'lists only leader_group' do
      get :index, params: { group_id: group.id, event_id: course.id, filters: {participant_type: :teamers} }
      expect(assigns(:participations)).to eq [@leader]
    end

    it 'lists only participant_group' do
      get :index, params: { group_id: group.id, event_id: course.id, filters: {participant_type: :participants} }
      expect(assigns(:participations)).to eq [@participant]
    end

    it 'exports csv' do
      expect do
        get :index, params: { group_id: group.id, event_id: course.id }, format: :csv
        expect(flash[:notice]).to match(/Export wird im Hintergrund gestartet und nach Fertigstellung heruntergeladen./)
      end.to change(Delayed::Job, :count).by(1)
    end

    def create(*roles)
      roles.map do |role_class|
        role = Fabricate(:event_role, type: role_class.name)
        Fabricate(:event_participation, event: course, roles: [role], state: 'assigned')
      end
    end
  end


  context 'custom attributes' do
    let(:custom_attrs) { { internal_comment: 'test', payed: '1' } }
    let(:participation) { Fabricate(:event_participation, event: course, participant: person) }

    before do
      course.update_attribute(:state, :application_open)
      sign_in(person)
    end

    def activate_participation
      participation.roles << Fabricate(:event_role, type: course.participant_types.first.name)
      participation.update(active: true, internal_comment: 'test', payed: true)
    end


    context 'with update permission' do
      let(:person) { people(:bulei) }

      it "updates attributes on create" do
        post :create, params: { group_id: group.id, event_id: course.id, event_participation: custom_attrs }
        expect(assigns(:participation)).to be_payed
        expect(assigns(:participation).internal_comment).to eq 'test'
      end

      it "updates attributes on update" do
        patch :update, params: { group_id: group.id, event_id: course.id, id: participation.id, event_participation: custom_attrs }
        expect(participation.reload).to be_payed
        expect(participation.reload.internal_comment).to eq 'test'
      end

      context 'rendered pages' do
        render_views
        before { activate_participation }

        it "includes columns in index page" do
          get :index, params: { group_id: group.id, event_id: course.id, filters: {participant_type: :participants} }
          html = Capybara::Node::Simple.new(response.body)
          expect(html).to have_content 'Ortsgruppe'
          expect(html).to have_content 'Bezahlt'
          expect(html).to have_content 'Interne Bemerkung'
        end

        it 'may sort by ortsgruppe' do
          skip "disabled because of sorting changes, see https://github.com/hitobito/hitobito/commit/31625073069fb93ed70e1b4290984fc9a1e926fd"

          Fabricate(:event_role,
                    type: course.participant_types.first.name,
                    participation: Fabricate(:event_participation,
                                             event: course,
                                             participant: Fabricate(:person,
                                                               ortsgruppe: groups(:stadtzh))))
          Fabricate(:event_role,
                    type: course.participant_types.first.name,
                    participation: Fabricate(:event_participation,
                                             event: course,
                                             participant: Fabricate(:person,
                                                               ortsgruppe: groups(:jona))))
          Fabricate(:event_role,
                    type: course.participant_types.first.name,
                    participation: Fabricate(:event_participation,
                                             event: course,
                                             participant: Fabricate(:person,
                                                               ortsgruppe: groups(:burgdorf))))

          get :index, params: { group_id: group.id, event_id: course.id, sort: :ortsgruppe }
          expect(assigns(:participations).map { |p| p.person.ortsgruppe_label }).to eq(['Burgdorf', 'Jona', 'StZH', nil])
        end

        it "includes attributes on show" do
          get :show, params: { group_id: group.id, event_id: course.id, id: participation.id }
          html = Capybara::Node::Simple.new(response.body)
          expect(html).to have_content 'Bezahlt'
          expect(html).to have_content 'Interne Bemerkung'
        end

        it "includes attributes on edit" do
          get :edit, params: { group_id: group.id, event_id: course.id, id: participation.id }
          html = Capybara::Node::Simple.new(response.body)
          expect(html).to have_content 'Bezahlt'
          expect(html).to have_content 'Interne Bemerkung'
        end

      end

    end


    context 'without update permission' do
      let(:person) { people(:al_altst) }

      it "ignores attributes on create" do
        post :create, params: { group_id: group.id, event_id: course.id, event_participation: custom_attrs }
        expect(assigns(:participation)).not_to be_payed
        expect(assigns(:participation).internal_comment).to be_blank
      end

      it "not allowed to update" do
        expect do
          patch :update, params: { group_id: group.id, event_id: course.id, id: participation.id, event_participation: custom_attrs }
        end.to raise_error CanCan::AccessDenied
      end

      context 'rendered pages' do
        render_views
        before { activate_participation }

        it "does not include columns on index page" do
          get :index, params: { group_id: group.id, event_id: course.id, filter: {participant_type: :participants} }
        end

        it "does not include attributes on show" do
          get :show, params: { group_id: group.id, event_id: course.id, id: participation.id }
        end

        it "does not render edit page" do
          expect do
            get :edit, params: { group_id: group.id, event_id: course.id, id: participation.id }
          end.to raise_error CanCan::AccessDenied
        end

        after do
          html = Capybara::Node::Simple.new(response.body)
          expect(html).not_to have_content 'Bezahlt'
          expect(html).not_to have_content 'Interne Bemerkung'
        end
      end

    end
  end

end

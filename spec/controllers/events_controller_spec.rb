# encoding: utf-8

#  Copyright (c) 2012-2014, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

require 'spec_helper'

describe EventsController do

  context 'event_course' do

    let(:group) { groups(:dachverband) }
    let(:date)  {{ label: 'foo', start_at_date: Date.today, finish_at_date: Date.today }}
    let(:event_kind_id) { Event::Kind.where(short_name: 'SLK').first.id }

    before { sign_in(people(:bulei)) }


    context 'POST#create' do

      it 'creates new event course with dates and contact' do
        contact = Person.first

        post :create, event: {  group_ids: [group.id],
                                name: 'foo',
                                kind_id: event_kind_id,
                                dates_attributes: [date],
                                contact_id: contact.id,
                                type: 'Event::Course' },
                      group_id: group.id


        event = assigns(:event)

        should redirect_to(group_event_path(group, event))

        event.should be_persisted
        event.dates.should have(1).item
        event.dates.first.should be_persisted
        event.contact.should eq contact
      end

      it 'creates new event course without contact' do
        post :create, event: {  group_ids: [group.id],
                                name: 'foo',
                                kind_id: event_kind_id,
                                contact_id: '',
                                dates_attributes: [date],
                                type: 'Event::Course' },
                      group_id: group.id

        event = assigns(:event)

        should redirect_to(group_event_path(group, event))
        event.should be_persisted
      end



      it 'should set application contact if only one is available' do
        post :create, event: {  group_ids: [group.id],
                                name: 'foo',
                                kind_id: event_kind_id,
                                dates_attributes: [date],
                                type: 'Event::Course' },
                                group_id: group.id

        event = assigns(:event)

        event.application_contact.should eq event.possible_contact_groups.first
        event.should be_persisted
      end

    end
  end


  context '#index filters based on type' do
    require_relative '../support/fabrication.rb'
    before { sign_in(people(:bulei)) }

    context 'Dachverband' do
      let(:group) { groups(:dachverband) }
      let!(:event) { Fabricate(:event, groups: [group]) }
      let!(:course) { Fabricate(:cevi_course, groups: [group]) }


      it 'lists events' do
        get :index, group_id: group.id, year: 2012
        assigns(:events).should eq [event, events(:top_event)]
      end

      it 'lists courses' do
        get :index, group_id: group.id, year: 2012, type: Event::Course.sti_name
        assigns(:events).should eq [course]
      end
    end

    context 'Mitgliederorganisation Bern' do
      let(:group) { groups(:be) }
      let!(:event) { Fabricate(:event, groups: [group]) }

      it 'lists event' do
        get :index, group_id: group.id, year: 2012
        assigns(:events).should eq [event]
      end
    end
  end

end

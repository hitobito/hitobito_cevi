# frozen_string_literal: true

#  Copyright (c) 2020, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

require 'spec_helper'

describe Person::LogController do
  include ActiveSupport::Testing::TimeHelpers

  before { sign_in(person) }

  context 'GET#index' do
    let(:person) { people(:bulei) }
    let(:group) { groups(:dachverband) }

    with_versioning do
      it 'deals with activated versioning' do
        expect(PaperTrail).to be_enabled
        expect(person).to be_versioned
      end

      it 'shows 0 versions if none are present' do
        expect(PaperTrail::Version.count).to be 0

        get :index, params: { group_id: group.id, id: person.id }

        expect(assigns(:versions)).to have(0).items
      end

      it 'shows 10 versions if 10 are present for the person' do
        10.times do
          person.nickname = Faker::Superhero.name
          person.save!
        end
        expect(PaperTrail::Version.count).to eq 10

        get :index, params: { group_id: group.id, id: person.id }

        expect(assigns(:versions)).to have(10).items
      end

      it 'shows entries of the last 3 months' do
        10.times do |i|
          person.nickname = Faker::Superhero.name
          travel_to (i.months + 1.week).ago # a little more than n month ago
          person.save!
        end
        travel_back

        expect(PaperTrail::Version.count).to eq 10
        expect(PaperTrail::Version.where(created_at: 3.months.ago..DateTime.current).count).to eq 2
        expect(Settings.people.visible_log_months).to eq 3

        get :index, params: { group_id: group.id, id: person.id }

        expect(assigns(:versions)).to have(2).items
      end

      it 'shows all entries if no setting is present' do
        10.times do |i|
          person.nickname = Faker::Superhero.name
          travel_to (i.months + 1.week).ago # a little more than n month ago
          person.save!
        end
        travel_back

        expect(PaperTrail::Version.count).to eq 10
        expect(PaperTrail::Version.where(created_at: 3.months.ago..DateTime.current).count).to eq 2

        prev_setting, Settings.people.visible_log_months = Settings.people.visible_log_months, nil
        expect(Settings.people.visible_log_months).to be_nil

        get :index, params: { group_id: group.id, id: person.id }

        expect(assigns(:versions)).to have(10).items

      ensure
        Settings.people.visible_log_months = prev_setting
      end
    end
  end
end

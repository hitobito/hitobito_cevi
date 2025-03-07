# frozen_string_literal: true

#  Copyright (c) 2023, CEVI Schweiz. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

require 'spec_helper'

describe Event::ParticipationDecorator, :draper_with_helpers do

  let(:person) { Fabricate(:person, first_name: 'John', last_name: 'Doe', nickname: nil, j_s_number: '1234123', nationality_j_s: 'CH') }
  let(:state) { 'applied' }
  let(:participation) { Event::Participation.new(state: state, person: person, event: events(:top_course)) }
  let(:decorator) { Event::ParticipationDecorator.new(participation) }

  describe '#j_s_number' do
    it 'delegates to person' do
      expect(decorator.j_s_number).to eq(person.j_s_number)
    end
  end

  describe '#nationality_j_s' do
    it 'delegates to person' do
      expect(decorator.nationality_j_s).to eq(person.nationality_j_s)
    end
  end

end

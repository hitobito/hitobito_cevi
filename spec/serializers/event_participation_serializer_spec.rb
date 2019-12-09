# encoding: utf-8

#  Copyright (c) 2012-2019, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

require 'spec_helper'

describe EventParticipationSerializer do
  let(:controller)    { double().as_null_object }
  let(:participation) { event_participations(:top_leader) }
  let(:serializer)    { EventParticipationSerializer.new(participation, controller) }

  let(:hash)          { serializer.to_hash.with_indifferent_access }

  subject { hash[:event_participations].first }

  it 'includes payed attribute' do
    expect(subject).to have_key('payed')
  end
end

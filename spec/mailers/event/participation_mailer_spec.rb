# frozen_string_literal: true

#  Copyright (c) 2012-2026, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

require "spec_helper"

describe Event::ParticipationMailer do
  before do
    SeedFu.quiet = true
    SeedFu.seed [Rails.root.join("db", "seeds")]
  end

  let(:person) { people(:bulei) }
  let(:contact) { Fabricate(:person, email: "kontakt@hitobito.example.com") }
  let(:event) { Fabricate(:event, groups: [groups(:dachverband)], contact: contact) }
  let(:participation) { Fabricate(:event_participation, event: event, participant: person) }
  let(:mail) { Event::ParticipationMailer.confirmation(participation) }

  it "sets reply_to to the event contact's email" do
    expect(mail.reply_to).to eq(["kontakt@hitobito.example.com"])
  end
end

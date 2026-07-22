# frozen_string_literal: true

#  Copyright (c) 2012-2026, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

require "spec_helper"

describe Event::RegisterMailer do
  before do
    SeedFu.quiet = true
    SeedFu.seed [Rails.root.join("db", "seeds")]
  end

  let(:contact) { Fabricate(:person, email: "kontakt@hitobito.example.com") }
  let(:group) { event.groups.first }
  let(:event) { Fabricate(:event, groups: [groups(:dachverband)], contact: contact) }
  let(:person) { Fabricate(:person, email: "fooo@example.com", reset_password_token: "abc") }
  let(:mail) { Event::RegisterMailer.register_login(person, group, event, "abcdef") }

  it "sets reply_to to the event contact's email" do
    expect(mail.reply_to).to eq(["kontakt@hitobito.example.com"])
  end
end

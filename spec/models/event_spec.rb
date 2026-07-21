# frozen_string_literal: true

#  Copyright (c) 2012-2026, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

require "spec_helper"

describe Cevi::Event do
  context "contact" do
    it "is invalid without contact" do
      event = Fabricate.build(:event, groups: [groups(:dachverband)], contact: nil)
      expect(event).not_to be_valid
      expect(event.errors[:base]).to include("Kontaktperson mit gültiger E-Mail-Adresse muss vorhanden sein, da E-Mails zum Anlass an diese Adresse gesendet werden.")
    end

    it "is invalid if contact has no email" do
      contact = Fabricate(:person, email: nil)
      event = Fabricate.build(:event, groups: [groups(:dachverband)], contact: contact)
      expect(event).not_to be_valid
      expect(event.errors[:base]).to include("Kontaktperson mit gültiger E-Mail-Adresse muss vorhanden sein, da E-Mails zum Anlass an diese Adresse gesendet werden.")
    end

    it "is valid with contact with valid email" do
      event = Fabricate(:event, groups: [groups(:dachverband)], contact: people(:bulei))
      expect(event).to be_valid
    end

    it "applies the same validation to Event::Course" do
      course = Fabricate.build(:cevi_course, groups: [groups(:zhshgl)], contact: nil)
      expect(course).not_to be_valid
      expect(course.errors[:base]).to include("Kontaktperson mit gültiger E-Mail-Adresse muss vorhanden sein, da E-Mails zum Anlass an diese Adresse gesendet werden.")
    end
  end
end

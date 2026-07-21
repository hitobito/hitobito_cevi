# frozen_string_literal: true

#  Copyright (c) 2012-2026, CEVI Regionalverband ZH-SH-GL. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

module Cevi::Event
  extend ActiveSupport::Concern

  included do
    validate :assert_contact_with_valid_email
  end

  private

  def assert_contact_with_valid_email
    errors.add(:base, :contact_email_missing) if contact.blank? || contact.email.blank?
  end
end

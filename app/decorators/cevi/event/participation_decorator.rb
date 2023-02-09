# frozen_string_literal: true

#  Copyright (c) 2023, CEVI Schweiz. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

module Cevi::Event::ParticipationDecorator
  extend ActiveSupport::Concern

  included do
    delegate :ahv_number, :j_s_number, :nationality_j_s, to: :person
  end
end

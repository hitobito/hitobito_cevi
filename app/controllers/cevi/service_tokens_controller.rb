# frozen_string_literal: true

# Copyright (c) 2022, CEVI Schweiz. This file is part of
# hitobito_pbs and licensed under the Affero General Public License version 3
# or later. See the COPYING file at the top-level directory or at
# https://github.com/hitobito/hitobito_cevi.

module Cevi::ServiceTokensController
  extend ActiveSupport::Concern

  def permitted_attrs
    permitted = self.class.permitted_attrs
    permitted << :show_donors if can?(:show_donors, group)
    permitted
  end

end

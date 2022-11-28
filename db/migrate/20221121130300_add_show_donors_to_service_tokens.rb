# frozen_string_literal: true

# Copyright (c) 2022, CEVI Schweiz. This file is part of
# hitobito_pbs and licensed under the Affero General Public License version 3
# or later. See the COPYING file at the top-level directory or at
# https://github.com/hitobito/hitobito_cevi.

class AddShowDonorsToServiceTokens < ActiveRecord::Migration[6.1]
  def change
    add_column :service_tokens, :show_donors, :boolean, null: false, default: false

    ServiceToken.reset_column_information
  end
end

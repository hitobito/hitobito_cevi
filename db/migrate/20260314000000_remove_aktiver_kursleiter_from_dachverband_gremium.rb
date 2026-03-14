#  Copyright (c) 2026, Cevi.DB Steuergruppe. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

class RemoveAktiverKursleiterFromDachverbandGremium < ActiveRecord::Migration[6.1]
  def up
    Role.where(type: 'Group::DachverbandGremium::AktiverKursleiter')
        .update_all(type: 'Group::DachverbandGremium::Mitglied')
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

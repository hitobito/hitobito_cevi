#  Copyright (c) 2026, Cevi.DB Steuergruppe. This file is part of
#  hitobito_cevi and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_cevi.

class RemoveAktiverKursleiterFromDachverbandGremium < ActiveRecord::Migration[6.1]
  OLD_TYPE = 'Group::DachverbandGremium::AktiverKursleiter'
  NEW_TYPE = 'Group::DachverbandGremium::Mitglied'

  def up
    # Migrate all active and past roles
    Role.with_inactive.where(type: OLD_TYPE).update_all(type: NEW_TYPE)

    # Update role type in PaperTrail version history so Verlauf remains viewable
    versions_table = PaperTrail::Version.table_name
    execute <<~SQL
      UPDATE #{versions_table}
      SET object = REPLACE(object, '#{OLD_TYPE}', '#{NEW_TYPE}')
      WHERE item_type = 'Role' AND object LIKE '%#{OLD_TYPE}%'
    SQL
    execute <<~SQL
      UPDATE #{versions_table}
      SET object_changes = REPLACE(object_changes, '#{OLD_TYPE}', '#{NEW_TYPE}')
      WHERE item_type = 'Role' AND object_changes LIKE '%#{OLD_TYPE}%'
    SQL

    # Remove from mailing list subscriptions and persisted person filters
    RelatedRoleType.where(role_type: OLD_TYPE).delete_all

    # Delete Group subscriptions that are now orphaned (no role types left)
    execute <<~SQL
      DELETE FROM subscriptions
      WHERE id IN (
        SELECT s.id
        FROM subscriptions s
        LEFT JOIN related_role_types rrt
          ON rrt.relation_id = s.id AND rrt.relation_type = 'Subscription'
        WHERE rrt.id IS NULL
        AND s.subscriber_type = 'Group'
      )
    SQL

    # Update persisted filter chains (PeopleFilter)
    execute <<~SQL
      UPDATE people_filters
      SET filter_chain = REPLACE(filter_chain, '#{OLD_TYPE}', '#{NEW_TYPE}')
      WHERE filter_chain LIKE '%#{OLD_TYPE}%'
    SQL

    # Update group self-registration role type
    execute <<~SQL
      UPDATE groups
      SET self_registration_role_type = '#{NEW_TYPE}'
      WHERE self_registration_role_type = '#{OLD_TYPE}'
    SQL

    # Update or remove pending person add requests for this role
    execute <<~SQL
      UPDATE person_add_requests
      SET role_type = '#{NEW_TYPE}'
      WHERE role_type = '#{OLD_TYPE}'
    SQL

    # Update invoice template items that reference this role type in their YAML parameters
    execute <<~SQL
      UPDATE period_invoice_template_items
      SET dynamic_cost_parameters = REPLACE(dynamic_cost_parameters, '#{OLD_TYPE}', '#{NEW_TYPE}')
      WHERE dynamic_cost_parameters LIKE '%#{OLD_TYPE}%'
    SQL

    # Update invoice items that reference this role type in their YAML parameters
    execute <<~SQL
      UPDATE invoice_items
      SET dynamic_cost_parameters = REPLACE(dynamic_cost_parameters, '#{OLD_TYPE}', '#{NEW_TYPE}')
      WHERE dynamic_cost_parameters LIKE '%#{OLD_TYPE}%'
    SQL
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

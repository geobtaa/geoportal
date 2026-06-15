class CreateKitheToResourcesBridges < ActiveRecord::Migration[7.2]
  disable_ddl_transaction!

  def up
    create_view :kithe_to_resources_bridge, version: 1, materialized: true

    execute <<~SQL
      CREATE UNIQUE INDEX CONCURRENTLY idx_kithe_to_resources_bridge_id
      ON kithe_to_resources_bridge (id);
    SQL
  end

  def down
    execute <<~SQL
      DROP INDEX CONCURRENTLY IF EXISTS idx_kithe_to_resources_bridge_id;
    SQL

    drop_view :kithe_to_resources_bridge, materialized: true
  end
end
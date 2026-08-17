class AddBridgeUpdatedAtToKitheModels < ActiveRecord::Migration[7.2]
  def up
    add_column :kithe_models, :bridge_updated_at, :datetime

    update_view :kithe_to_resources_bridge,
                version: 7,
                revert_to_version: 6,
                materialized: true
  end

  def down
    drop_view :kithe_to_resources_bridge, materialized: true
    remove_column :kithe_models, :bridge_updated_at
    create_view :kithe_to_resources_bridge, version: 6, materialized: true
    add_index :kithe_to_resources_bridge,
              :id,
              unique: true,
              name: :kithe_to_resources_bridge_id_uidx
  end
end

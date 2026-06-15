class UpdateKitheToResourcesBridgeToVersion2 < ActiveRecord::Migration[7.2]
  def up
    update_view :kithe_to_resources_bridge,
                version: 2,
                revert_to_version: 1,
                materialized: true
  end

  def down
    update_view :kithe_to_resources_bridge,
                version: 1,
                revert_to_version: 2,
                materialized: true
  end
end
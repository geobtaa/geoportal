class UpdateKitheToResourcesBridgeToVersion6 < ActiveRecord::Migration[7.2]
  def up
    update_view :kithe_to_resources_bridge,
                version: 6,
                revert_to_version: 5,
                materialized: true
  end

  def down
    update_view :kithe_to_resources_bridge,
                version: 5,
                revert_to_version: 6,
                materialized: true
  end
end

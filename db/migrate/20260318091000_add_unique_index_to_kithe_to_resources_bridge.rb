# frozen_string_literal: true

class AddUniqueIndexToKitheToResourcesBridge < ActiveRecord::Migration[7.2]
  def up
    execute <<~SQL
      CREATE UNIQUE INDEX IF NOT EXISTS kithe_to_resources_bridge_id_uidx
      ON kithe_to_resources_bridge (id);
    SQL
  end

  def down
    execute "DROP INDEX IF EXISTS kithe_to_resources_bridge_id_uidx;"
  end
end


class CreateKitheBridgeDeletions < ActiveRecord::Migration[7.2]
  def change
    create_table :kithe_bridge_deletions do |t|
      t.string :friendlier_id, null: false
      t.uuid :kithe_model_id, null: false
      t.string :title
      t.bigint :import_id
      t.string :publication_state
      t.string :geomg_id_s
      t.datetime :deleted_at, null: false

      t.timestamps
    end

    add_index :kithe_bridge_deletions, :friendlier_id, unique: true
    add_index :kithe_bridge_deletions, :kithe_model_id
    add_index :kithe_bridge_deletions, :deleted_at
  end
end

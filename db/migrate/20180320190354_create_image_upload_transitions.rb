class CreateImageUploadTransitions < ActiveRecord::Migration[5.1]
  def change
    create_table :image_upload_transitions do |t|
      t.string :to_state, null: false
      t.text :metadata
      t.integer :sort_key, null: false
      t.integer :solr_document_sidecar_id, null: false
      t.boolean :most_recent, null: false

      # If you decide not to include an updated timestamp column in your transition
      # table, you'll need to configure the `updated_timestamp_column` setting in your
      # migration class.
      t.timestamps null: false
    end

    # Foreign keys are optional, but highly recommended
    # add_foreign_key :image_upload_transitions, :solr_document_sidecars

    add_index(:image_upload_transitions,
              [:solr_document_sidecar_id, :sort_key],
              unique: true,
              name: "index_image_upload_transitions_parent_sort")
    add_index(:image_upload_transitions,
              [:solr_document_sidecar_id, :most_recent],
              unique: true,
              where: 'most_recent',
              name: "index_image_upload_transitions_parent_most_recent")
  end
end

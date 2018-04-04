class CreateImageUploadTransitions < ActiveRecord::Migration[5.1]
  def change
    create_table :image_upload_transitions do |t|
      t.string :to_state, null: false
      t.text :metadata
      t.integer :sort_key, null: false
      t.references :solr_document_sidecar, foreign_key: true
      t.boolean :most_recent, null: false

      # If you decide not to include an updated timestamp column in your transition
      # table, you'll need to configure the `updated_timestamp_column` setting in your
      # migration class.
      t.timestamps null: false
    end

    add_index(:image_upload_transitions,
              [:solr_document_sidecar_id, :sort_key],
              unique: true,
              name: "index_image_upload_transitions_parent_sort")

    # @TODO: Code is erroring on state change
    #
    # Queued => Processing => ERROR
    # Error performing StoreImageJob (Job ID: fdb90f5e-024f-40fe-8917-4e9f7c86d495) from Inline(default) in 3366.02ms:
    # Statesman::TransitionConflictError (Mysql2::Error: Duplicate entry '1-0' for key 'index_image_upload_transitions_parent_most_recent': UPDATE `image_upload_transitions` SET `image_upload_transitions`.`most_recent` = 0, `image_upload_transitions`.`updated_at` = '2018-04-04 16:30:48' WHERE `image_upload_transitions`.`solr_document_sidecar_id` = 1 AND `image_upload_transitions`.`most_recent` = 1):
    #add_index(:image_upload_transitions,
    #          [:solr_document_sidecar_id, :most_recent],
    #          unique: true,
    #          where: 'most_recent',
    #          name: "index_image_upload_transitions_parent_most_recent")
  end
end

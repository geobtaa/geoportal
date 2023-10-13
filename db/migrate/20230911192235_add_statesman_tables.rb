class AddStatesmanTables < ActiveRecord::Migration[6.1]
  def change

    unless ActiveRecord::Base.connection.table_exists? 'image_upload_transitions'
      # Image Upload Transitions
      create_table "image_upload_transitions", force: :cascade do |t|
        t.string "to_state", null: false
        t.text "metadata"
        t.integer "sort_key", null: false
        t.bigint "solr_document_sidecar_id"
        t.boolean "most_recent", null: false
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
        t.index ["solr_document_sidecar_id", "sort_key"], name: "index_image_upload_transitions_parent_sort", unique: true
        t.index ["solr_document_sidecar_id"], name: "index_image_upload_transitions_on_solr_document_sidecar_id"
      end
    end

    unless ActiveRecord::Base.connection.table_exists? 'sidecar_image_transitions'
      # Sidecar Image Transitions
      create_table "sidecar_image_transitions", force: :cascade do |t|
        t.string "to_state", null: false
        t.text "metadata"
        t.integer "sort_key", null: false
        t.bigint "solr_document_sidecar_id", null: false
        t.boolean "most_recent"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
        t.index ["solr_document_sidecar_id", "sort_key"], name: "index_sidecar_image_transitions_parent_sort", unique: true
      end
    end

    unless ActiveRecord::Base.connection.table_exists? 'solr_document_uris'
      # Solr Document URIs
      create_table "solr_document_uris", force: :cascade do |t|
        t.string "document_id"
        t.string "document_type"
        t.string "uri_key"
        t.string "uri_value"
        t.bigint "version"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
        t.index ["document_type", "document_id"], name: "solr_document_uris_solr_document"
      end
    end

    unless ActiveRecord::Base.connection.table_exists? 'uri_transitions'
      # URI Transitions
      create_table "uri_transitions", force: :cascade do |t|
        t.string "to_state", null: false
        t.text "metadata"
        t.integer "sort_key", null: false
        t.bigint "solr_document_uri_id"
        t.boolean "most_recent", null: false
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
        t.index ["solr_document_uri_id", "sort_key"], name: "index_uri_transitions_parent_sort", unique: true
        t.index ["solr_document_uri_id"], name: "index_uri_transitions_on_solr_document_uri_id"
      end
    end

    # Indexes
    unless foreign_key_exists?(:image_upload_transitions, :solr_document_sidecars)
      add_foreign_key "image_upload_transitions", "solr_document_sidecars"
    end

    unless foreign_key_exists?(:sidecar_image_transitions, :solr_document_sidecars)
      add_foreign_key "sidecar_image_transitions", "solr_document_sidecars"
    end

    unless foreign_key_exists?(:uri_transitions, :solr_document_uris)
      add_foreign_key "uri_transitions", "solr_document_uris"
    end
  end
end

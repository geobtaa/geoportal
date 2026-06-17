# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2026_06_17_183000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_function :kithe_models_friendlier_id_gen, sql_definition: <<-'SQL'
      CREATE OR REPLACE FUNCTION public.kithe_models_friendlier_id_gen(min_value bigint, max_value bigint)
       RETURNS text
       LANGUAGE plpgsql
      AS $function$
        DECLARE
          new_id_int bigint;
          new_id_str character varying := '';
          done bool;
          tries integer;
          alphabet char[] := ARRAY['0','1','2','3','4','5','6','7','8','9',
            'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n',
            'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'];
          alphabet_length integer := array_length(alphabet, 1);

        BEGIN
          done := false;
          tries := 0;
          WHILE (NOT done) LOOP
            tries := tries + 1;
            IF (tries > 3) THEN
              RAISE 'Could not find non-conflicting friendlier_id in 3 tries';
            END IF;

            new_id_int := trunc(random() * (max_value - min_value) + min_value);

            -- convert bigint to a Base-36 alphanumeric string
            -- see https://web.archive.org/web/20130420084605/http://www.jamiebegin.com/base36-conversion-in-postgresql/
            -- https://gist.github.com/btbytes/7159902
            WHILE new_id_int != 0 LOOP
              new_id_str := alphabet[(new_id_int % alphabet_length)+1] || new_id_str;
              new_id_int := new_id_int / alphabet_length;
            END LOOP;

            done := NOT exists(SELECT 1 FROM kithe_models WHERE friendlier_id=new_id_str);
          END LOOP;
          RETURN new_id_str;
        END;
        $function$
  SQL

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", precision: nil, null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "blacklight_allmaps_sidecars", force: :cascade do |t|
    t.string "solr_document_id"
    t.string "document_type", default: "SolrDocument"
    t.string "manifest_id"
    t.boolean "annotated", default: false
    t.string "allmaps_id"
    t.text "iiif_manifest"
    t.text "allmaps_annotation"
    t.bigint "solr_version"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["allmaps_id"], name: "index_blacklight_allmaps_sidecars_on_allmaps_id"
    t.index ["manifest_id"], name: "index_blacklight_allmaps_sidecars_on_manifest_id"
    t.index ["solr_document_id"], name: "index_blacklight_allmaps_sidecars_on_solr_document_id"
  end

  create_table "blazer_audits", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "query_id"
    t.text "statement"
    t.string "data_source"
    t.datetime "created_at", precision: nil
    t.index ["query_id"], name: "index_blazer_audits_on_query_id"
    t.index ["user_id"], name: "index_blazer_audits_on_user_id"
  end

  create_table "blazer_checks", force: :cascade do |t|
    t.bigint "creator_id"
    t.bigint "query_id"
    t.string "state"
    t.string "schedule"
    t.text "emails"
    t.text "slack_channels"
    t.string "check_type"
    t.text "message"
    t.datetime "last_run_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_blazer_checks_on_creator_id"
    t.index ["query_id"], name: "index_blazer_checks_on_query_id"
  end

  create_table "blazer_dashboard_queries", force: :cascade do |t|
    t.bigint "dashboard_id"
    t.bigint "query_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dashboard_id"], name: "index_blazer_dashboard_queries_on_dashboard_id"
    t.index ["query_id"], name: "index_blazer_dashboard_queries_on_query_id"
  end

  create_table "blazer_dashboards", force: :cascade do |t|
    t.bigint "creator_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_blazer_dashboards_on_creator_id"
  end

  create_table "blazer_queries", force: :cascade do |t|
    t.bigint "creator_id"
    t.string "name"
    t.text "description"
    t.text "statement"
    t.string "data_source"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_blazer_queries_on_creator_id"
  end

  create_table "blazer_uploads", force: :cascade do |t|
    t.bigint "creator_id"
    t.string "table"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_blazer_uploads_on_creator_id"
  end

  create_table "bookmarks", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "user_type"
    t.string "document_id"
    t.string "title"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "document_type"
    t.index ["user_id"], name: "index_bookmarks_on_user_id"
  end

  create_table "bulk_action_document_transitions", force: :cascade do |t|
    t.string "to_state", null: false
    t.text "metadata", default: "{}"
    t.integer "sort_key", null: false
    t.integer "bulk_action_document_id", null: false
    t.boolean "most_recent", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bulk_action_document_id", "most_recent"], name: "index_bulk_action_document_transitions_parent_most_recent", unique: true, where: "most_recent"
    t.index ["bulk_action_document_id", "sort_key"], name: "index_bulk_action_document_transitions_parent_sort", unique: true
  end

  create_table "bulk_action_documents", force: :cascade do |t|
    t.string "friendlier_id", null: false
    t.integer "version", null: false
    t.bigint "bulk_action_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "document_id"
    t.index ["bulk_action_id"], name: "index_bulk_action_documents_on_bulk_action_id"
  end

  create_table "bulk_action_transitions", force: :cascade do |t|
    t.string "to_state", null: false
    t.text "metadata", default: "{}"
    t.integer "sort_key", null: false
    t.integer "bulk_action_id", null: false
    t.boolean "most_recent", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bulk_action_id", "most_recent"], name: "index_bulk_action_transitions_parent_most_recent", unique: true, where: "most_recent"
    t.index ["bulk_action_id", "sort_key"], name: "index_bulk_action_transitions_parent_sort", unique: true
  end

  create_table "bulk_actions", force: :cascade do |t|
    t.string "name"
    t.string "request", null: false
    t.string "scope", null: false
    t.string "field_name", null: false
    t.string "field_value", null: false
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "document_data_dictionaries", force: :cascade do |t|
    t.string "friendlier_id"
    t.string "name"
    t.text "description"
    t.text "staff_notes"
    t.string "tags", limit: 4096, default: "", null: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "document_data_dictionary_entries", force: :cascade do |t|
    t.bigint "document_data_dictionary_id", null: false
    t.string "friendlier_id"
    t.string "field_name"
    t.string "field_type"
    t.string "values"
    t.string "definition"
    t.string "definition_source"
    t.string "parent_field_name"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document_data_dictionary_id"], name: "idx_data_dict_entries_doc_dict_id"
  end

  create_table "document_distributions", force: :cascade do |t|
    t.string "friendlier_id", null: false
    t.bigint "reference_type_id", null: false
    t.string "url"
    t.string "label"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "import_distribution_id"
    t.index ["friendlier_id", "reference_type_id", "url"], name: "document_references_unique_index", unique: true
    t.index ["reference_type_id"], name: "index_document_distributions_on_reference_type_id"
  end

  create_table "document_downloads", force: :cascade do |t|
    t.string "friendlier_id"
    t.string "label"
    t.string "value"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "document_licensed_accesses", force: :cascade do |t|
    t.string "friendlier_id", null: false
    t.string "institution_code", null: false
    t.text "access_url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "document_thumbnail_transitions", force: :cascade do |t|
    t.string "to_state", null: false
    t.text "metadata", default: "{}"
    t.integer "sort_key", null: false
    t.uuid "kithe_model_id", null: false
    t.boolean "most_recent", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["kithe_model_id", "most_recent"], name: "thumbnail_transitions_parent_most_recent", unique: true, where: "most_recent"
    t.index ["kithe_model_id", "sort_key"], name: "thumbnail_transitions_parent_sort", unique: true
  end

  create_table "document_transitions", force: :cascade do |t|
    t.string "to_state", null: false
    t.text "metadata", default: "{}"
    t.integer "sort_key", null: false
    t.uuid "kithe_model_id", null: false
    t.boolean "most_recent", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["kithe_model_id", "most_recent"], name: "index_document_transitions_parent_most_recent", unique: true, where: "most_recent"
    t.index ["kithe_model_id", "sort_key"], name: "index_document_transitions_parent_sort", unique: true
  end

  create_table "elements", force: :cascade do |t|
    t.string "label", null: false
    t.string "solr_field", null: false
    t.string "field_definition"
    t.string "field_type", null: false
    t.boolean "required", default: false, null: false
    t.boolean "repeatable", default: false, null: false
    t.boolean "formable", default: true, null: false
    t.string "placeholder_text"
    t.string "data_entry_hint"
    t.string "test_fixture_example"
    t.string "controlled_vocabulary"
    t.string "js_behaviors"
    t.text "html_attributes"
    t.boolean "display_only_on_persisted", default: false, null: false
    t.boolean "importable", default: true, null: false
    t.boolean "import_deliminated", default: false, null: false
    t.string "import_transformation_method"
    t.boolean "exportable", default: true, null: false
    t.string "export_transformation_method"
    t.boolean "indexable", default: true, null: false
    t.string "index_transformation_method"
    t.string "validation_method"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
  end

  create_table "form_elements", force: :cascade do |t|
    t.string "type", null: false
    t.string "label"
    t.string "element_solr_field"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "image_upload_transitions", force: :cascade do |t|
    t.string "to_state", null: false
    t.text "metadata"
    t.integer "sort_key", null: false
    t.bigint "solr_document_sidecar_id", null: false
    t.boolean "most_recent", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["solr_document_sidecar_id", "sort_key"], name: "index_image_upload_transitions_parent_sort", unique: true
    t.index ["solr_document_sidecar_id"], name: "index_image_upload_transitions_on_solr_document_sidecar_id"
  end

  create_table "import_distribution_transitions", force: :cascade do |t|
    t.string "to_state", null: false
    t.text "metadata", default: "{}"
    t.integer "sort_key", null: false
    t.integer "import_distribution_id", null: false
    t.boolean "most_recent", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["import_distribution_id", "most_recent"], name: "index_import_distribution_transitions_parent_most_recent", unique: true, where: "most_recent"
    t.index ["import_distribution_id", "sort_key"], name: "index_import_distribution_transitions_parent_sort", unique: true
  end

  create_table "import_distributions", force: :cascade do |t|
    t.string "name"
    t.string "source"
    t.text "description"
    t.string "filename"
    t.integer "row_count"
    t.text "headers", default: [], array: true
    t.string "encoding"
    t.string "content_type"
    t.string "extension"
    t.boolean "validity", default: false
    t.text "validation_result"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "import_document_distribution_transitions", force: :cascade do |t|
    t.string "to_state", null: false
    t.text "metadata", default: "{}"
    t.integer "sort_key", null: false
    t.integer "import_document_distribution_id", null: false
    t.boolean "most_recent", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["import_document_distribution_id", "most_recent"], name: "index_import_doc_distribution_transitions_parent_most_recent", unique: true, where: "most_recent"
    t.index ["import_document_distribution_id", "sort_key"], name: "index_import_doc_distribution_transitions_parent_sort", unique: true
  end

  create_table "import_document_distributions", force: :cascade do |t|
    t.string "friendlier_id"
    t.string "reference_type"
    t.text "distribution_url"
    t.string "label"
    t.bigint "import_distribution_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["import_distribution_id"], name: "index_import_distributions_on_import_distribution_id"
  end

  create_table "import_document_transitions", force: :cascade do |t|
    t.string "to_state", null: false
    t.text "metadata", default: "{}"
    t.integer "sort_key", null: false
    t.integer "import_document_id", null: false
    t.boolean "most_recent", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["import_document_id", "most_recent"], name: "index_import_document_transitions_parent_most_recent", unique: true, where: "most_recent"
    t.index ["import_document_id", "sort_key"], name: "index_import_document_transitions_parent_sort", unique: true
  end

  create_table "import_documents", force: :cascade do |t|
    t.string "friendlier_id", null: false
    t.string "title", null: false
    t.json "json_attributes", default: "{}"
    t.bigint "import_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["import_id"], name: "index_import_documents_on_import_id"
  end

  create_table "import_transitions", force: :cascade do |t|
    t.string "to_state", null: false
    t.text "metadata", default: "{}"
    t.integer "sort_key", null: false
    t.integer "import_id", null: false
    t.boolean "most_recent", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["import_id", "most_recent"], name: "index_import_transitions_parent_most_recent", unique: true, where: "most_recent"
    t.index ["import_id", "sort_key"], name: "index_import_transitions_parent_sort", unique: true
  end

  create_table "imports", force: :cascade do |t|
    t.string "name", null: false
    t.string "source"
    t.text "description"
    t.string "filename"
    t.integer "row_count"
    t.text "headers", default: [], array: true
    t.string "encoding"
    t.string "content_type"
    t.string "extension"
    t.boolean "validity", default: false, null: false
    t.text "validation_result"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
  end

  create_table "kithe_bridge_deletions", force: :cascade do |t|
    t.string "friendlier_id", null: false
    t.uuid "kithe_model_id", null: false
    t.string "title"
    t.bigint "import_id"
    t.string "publication_state"
    t.string "geomg_id_s"
    t.datetime "deleted_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_kithe_bridge_deletions_on_deleted_at"
    t.index ["friendlier_id"], name: "index_kithe_bridge_deletions_on_friendlier_id", unique: true
    t.index ["kithe_model_id"], name: "index_kithe_bridge_deletions_on_kithe_model_id"
  end

  create_table "kithe_derivatives", force: :cascade do |t|
    t.string "key", null: false
    t.jsonb "file_data"
    t.uuid "asset_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["asset_id", "key"], name: "index_kithe_derivatives_on_asset_id_and_key", unique: true
    t.index ["asset_id"], name: "index_kithe_derivatives_on_asset_id"
  end

  create_table "kithe_model_contains", id: false, force: :cascade do |t|
    t.uuid "containee_id"
    t.uuid "container_id"
    t.index ["containee_id"], name: "index_kithe_model_contains_on_containee_id"
    t.index ["container_id"], name: "index_kithe_model_contains_on_container_id"
  end

  create_table "kithe_models", id: :uuid, default: -> { "public.gen_random_uuid()" }, force: :cascade do |t|
    t.string "title", null: false
    t.string "type", null: false
    t.integer "position"
    t.jsonb "json_attributes"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.uuid "parent_id"
    t.string "friendlier_id", default: -> { "kithe_models_friendlier_id_gen('2821109907456'::bigint, '101559956668415'::bigint)" }, null: false
    t.jsonb "file_data"
    t.uuid "representative_id"
    t.uuid "leaf_representative_id"
    t.integer "kithe_model_type", null: false
    t.bigint "import_id"
    t.string "publication_state", default: "draft"
    t.index ["friendlier_id"], name: "index_kithe_models_on_friendlier_id", unique: true
    t.index ["import_id"], name: "index_kithe_models_on_import_id"
    t.index ["leaf_representative_id"], name: "index_kithe_models_on_leaf_representative_id"
    t.index ["parent_id"], name: "index_kithe_models_on_parent_id"
    t.index ["representative_id"], name: "index_kithe_models_on_representative_id"
  end

  create_table "mappings", force: :cascade do |t|
    t.string "source_header"
    t.string "destination_field"
    t.boolean "delimited"
    t.string "transformation_method"
    t.bigint "import_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["import_id"], name: "index_mappings_on_import_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "recipient_type", null: false
    t.bigint "recipient_id", null: false
    t.string "type", null: false
    t.jsonb "params"
    t.datetime "read_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["read_at"], name: "index_notifications_on_read_at"
    t.index ["recipient_type", "recipient_id"], name: "index_notifications_on_recipient"
  end

  create_table "pointless_feedback_messages", force: :cascade do |t|
    t.string "name"
    t.string "email_address"
    t.string "topic"
    t.text "description"
    t.text "previous_url"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "reference_types", force: :cascade do |t|
    t.string "name"
    t.string "reference_type"
    t.string "reference_uri"
    t.boolean "label", default: false
    t.text "note"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "searches", force: :cascade do |t|
    t.text "query_params"
    t.integer "user_id"
    t.string "user_type"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["user_id"], name: "index_searches_on_user_id"
  end

  create_table "sidecar_image_transitions", force: :cascade do |t|
    t.string "to_state", null: false
    t.text "metadata"
    t.integer "sort_key", null: false
    t.bigint "solr_document_sidecar_id", null: false
    t.boolean "most_recent"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["solr_document_sidecar_id", "sort_key"], name: "index_sidecar_image_transitions_parent_sort", unique: true
  end

  create_table "solr_document_sidecars", force: :cascade do |t|
    t.string "document_id"
    t.string "document_type"
    t.string "cw_image"
    t.bigint "version"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["document_type", "document_id"], name: "solr_document_sidecars_solr_document"
  end

  create_table "solr_document_uris", force: :cascade do |t|
    t.string "document_id"
    t.string "document_type"
    t.string "uri_key"
    t.string "uri_value"
    t.bigint "version"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["document_type", "document_id"], name: "solr_document_uris_solr_document"
  end

  create_table "uri_transitions", force: :cascade do |t|
    t.string "to_state", null: false
    t.text "metadata"
    t.integer "sort_key", null: false
    t.bigint "solr_document_uri_id"
    t.boolean "most_recent", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["solr_document_uri_id", "sort_key"], name: "index_uri_transitions_parent_sort", unique: true
    t.index ["solr_document_uri_id"], name: "index_uri_transitions_on_solr_document_uri_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "guest", default: false
    t.string "invitation_token"
    t.datetime "invitation_created_at", precision: nil
    t.datetime "invitation_sent_at", precision: nil
    t.datetime "invitation_accepted_at", precision: nil
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.boolean "admin", default: true, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by_type_and_invited_by_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.uuid "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at", precision: nil
    t.text "object_changes"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "bulk_action_document_transitions", "bulk_action_documents"
  add_foreign_key "bulk_action_documents", "bulk_actions"
  add_foreign_key "bulk_action_transitions", "bulk_actions"
  add_foreign_key "document_data_dictionary_entries", "document_data_dictionaries"
  add_foreign_key "document_distributions", "reference_types"
  add_foreign_key "image_upload_transitions", "solr_document_sidecars"
  add_foreign_key "import_document_transitions", "import_documents"
  add_foreign_key "import_documents", "imports"
  add_foreign_key "import_transitions", "imports"
  add_foreign_key "kithe_derivatives", "kithe_models", column: "asset_id"
  add_foreign_key "kithe_model_contains", "kithe_models", column: "containee_id"
  add_foreign_key "kithe_model_contains", "kithe_models", column: "container_id"
  add_foreign_key "kithe_models", "kithe_models", column: "leaf_representative_id"
  add_foreign_key "kithe_models", "kithe_models", column: "parent_id"
  add_foreign_key "kithe_models", "kithe_models", column: "representative_id"
  add_foreign_key "mappings", "imports"
  add_foreign_key "sidecar_image_transitions", "solr_document_sidecars"
  add_foreign_key "uri_transitions", "solr_document_uris"

  create_view "kithe_to_resources_bridge", materialized: true, sql_definition: <<-SQL
      WITH live_document_ids AS (
           SELECT kithe_models.id,
              kithe_models.title,
              kithe_models.type,
              kithe_models."position",
              kithe_models.json_attributes,
              kithe_models.created_at,
              kithe_models.updated_at,
              kithe_models.parent_id,
              kithe_models.friendlier_id,
              kithe_models.file_data,
              kithe_models.representative_id,
              kithe_models.leaf_representative_id,
              kithe_models.kithe_model_type,
              kithe_models.import_id,
              kithe_models.publication_state,
              COALESCE(kithe_models.friendlier_id, (kithe_models.id)::character varying) AS bridge_id
             FROM kithe_models
            WHERE ((kithe_models.type)::text = 'Document'::text)
          ), relationship_values AS (
           SELECT live_document_ids.bridge_id AS subject_id,
              relation_fields.field_name,
              btrim(related_ids.related_id) AS object_id
             FROM ((live_document_ids
               CROSS JOIN LATERAL ( VALUES ('dct_relation_sm'::text,(live_document_ids.json_attributes -> 'dct_relation_sm'::text)), ('pcdm_memberOf_sm'::text,(live_document_ids.json_attributes -> 'pcdm_memberOf_sm'::text)), ('dct_isPartOf_sm'::text,(live_document_ids.json_attributes -> 'dct_isPartOf_sm'::text)), ('dct_source_sm'::text,(live_document_ids.json_attributes -> 'dct_source_sm'::text)), ('dct_isVersionOf_sm'::text,(live_document_ids.json_attributes -> 'dct_isVersionOf_sm'::text)), ('dct_replaces_sm'::text,(live_document_ids.json_attributes -> 'dct_replaces_sm'::text)), ('dct_isReplacedBy_sm'::text,(live_document_ids.json_attributes -> 'dct_isReplacedBy_sm'::text))) relation_fields(field_name, raw_value))
               CROSS JOIN LATERAL jsonb_array_elements_text(
                  CASE
                      WHEN ((relation_fields.raw_value IS NULL) OR (relation_fields.raw_value = 'null'::jsonb)) THEN '[]'::jsonb
                      WHEN (jsonb_typeof(relation_fields.raw_value) = 'array'::text) THEN relation_fields.raw_value
                      ELSE jsonb_build_array(relation_fields.raw_value)
                  END) related_ids(related_id))
            WHERE (btrim(related_ids.related_id) <> ''::text)
          ), relationship_exports AS (
           SELECT relationship_values.subject_id AS document_id,
              relationship_values.field_name,
              relationship_values.object_id AS related_id
             FROM relationship_values
          UNION
           SELECT relationship_values.object_id AS document_id,
              'dct_relation_sm'::text AS field_name,
              relationship_values.subject_id AS related_id
             FROM relationship_values
            WHERE (relationship_values.field_name = 'dct_relation_sm'::text)
          UNION
           SELECT relationship_values.object_id AS document_id,
              'dct_isReplacedBy_sm'::text AS field_name,
              relationship_values.subject_id AS related_id
             FROM relationship_values
            WHERE (relationship_values.field_name = 'dct_replaces_sm'::text)
          UNION
           SELECT relationship_values.object_id AS document_id,
              'dct_replaces_sm'::text AS field_name,
              relationship_values.subject_id AS related_id
             FROM relationship_values
            WHERE (relationship_values.field_name = 'dct_isReplacedBy_sm'::text)
          ), live_documents AS (
           SELECT live_document_ids.bridge_id AS id,
              live_document_ids.title AS dct_title_s,
              live_document_ids.publication_state,
              (live_document_ids.import_id)::character varying AS import_id,
              ARRAY( SELECT jsonb_array_elements_text(
                          CASE
                              WHEN (((live_document_ids.json_attributes -> 'dct_alternative_sm'::text) IS NULL) OR ((live_document_ids.json_attributes -> 'dct_alternative_sm'::text) = 'null'::jsonb)) THEN '[]'::jsonb
                              WHEN (jsonb_typeof((live_document_ids.json_attributes -> 'dct_alternative_sm'::text)) = 'array'::text) THEN (live_document_ids.json_attributes -> 'dct_alternative_sm'::text)
                              ELSE jsonb_build_array((live_document_ids.json_attributes -> 'dct_alternative_sm'::text))
                          END) AS jsonb_array_elements_text) AS dct_alternative_sm,
              ARRAY( SELECT jsonb_array_elements_text(
                          CASE
                              WHEN (((live_document_ids.json_attributes -> 'dct_description_sm'::text) IS NULL) OR ((live_document_ids.json_attributes -> 'dct_description_sm'::text) = 'null'::jsonb)) THEN '[]'::jsonb
                              WHEN (jsonb_typeof((live_document_ids.json_attributes -> 'dct_description_sm'::text)) = 'array'::text) THEN (live_document_ids.json_attributes -> 'dct_description_sm'::text)
                              ELSE jsonb_build_array((live_document_ids.json_attributes -> 'dct_description_sm'::text))
                          END) AS jsonb_array_elements_text) AS dct_description_sm,
              ARRAY( SELECT jsonb_array_elements_text(
                          CASE
                              WHEN (((live_document_ids.json_attributes -> 'dct_language_sm'::text) IS NULL) OR ((live_document_ids.json_attributes -> 'dct_language_sm'::text) = 'null'::jsonb)) THEN '[]'::jsonb
                              WHEN (jsonb_typeof((live_document_ids.json_attributes -> 'dct_language_sm'::text)) = 'array'::text) THEN (live_document_ids.json_attributes -> 'dct_language_sm'::text)
                              ELSE jsonb_build_array((live_document_ids.json_attributes -> 'dct_language_sm'::text))
                          END) AS jsonb_array_elements_text) AS dct_language_sm,
              ARRAY( SELECT jsonb_array_elements_text(
                          CASE
                              WHEN (((live_document_ids.json_attributes -> 'gbl_displayNote_sm'::text) IS NULL) OR ((live_document_ids.json_attributes -> 'gbl_displayNote_sm'::text) = 'null'::jsonb)) THEN '[]'::jsonb
                              WHEN (jsonb_typeof((live_document_ids.json_attributes -> 'gbl_displayNote_sm'::text)) = 'array'::text) THEN (live_document_ids.json_attributes -> 'gbl_displayNote_sm'::text)
                              ELSE jsonb_build_array((live_document_ids.json_attributes -> 'gbl_displayNote_sm'::text))
                          END) AS jsonb_array_elements_text) AS "gbl_displayNote_sm",
              ARRAY( SELECT jsonb_array_elements_text(
                          CASE
                              WHEN (((live_document_ids.json_attributes -> 'dct_creator_sm'::text) IS NULL) OR ((live_document_ids.json_attributes -> 'dct_creator_sm'::text) = 'null'::jsonb)) THEN '[]'::jsonb
                              WHEN (jsonb_typeof((live_document_ids.json_attributes -> 'dct_creator_sm'::text)) = 'array'::text) THEN (live_document_ids.json_attributes -> 'dct_creator_sm'::text)
                              ELSE jsonb_build_array((live_document_ids.json_attributes -> 'dct_creator_sm'::text))
                          END) AS jsonb_array_elements_text) AS dct_creator_sm,
              ARRAY( SELECT jsonb_array_elements_text(
                          CASE
                              WHEN (((live_document_ids.json_attributes -> 'dct_publisher_sm'::text) IS NULL) OR ((live_document_ids.json_attributes -> 'dct_publisher_sm'::text) = 'null'::jsonb)) THEN '[]'::jsonb
                              WHEN (jsonb_typeof((live_document_ids.json_attributes -> 'dct_publisher_sm'::text)) = 'array'::text) THEN (live_document_ids.json_attributes -> 'dct_publisher_sm'::text)
                              ELSE jsonb_build_array((live_document_ids.json_attributes -> 'dct_publisher_sm'::text))
                          END) AS jsonb_array_elements_text) AS dct_publisher_sm,
              (live_document_ids.json_attributes ->> 'schema_provider_s'::text) AS schema_provider_s,
              ARRAY( SELECT jsonb_array_elements_text(
                          CASE
                              WHEN (((live_document_ids.json_attributes -> 'gbl_resourceClass_sm'::text) IS NULL) OR ((live_document_ids.json_attributes -> 'gbl_resourceClass_sm'::text) = 'null'::jsonb)) THEN '[]'::jsonb
                              WHEN (jsonb_typeof((live_document_ids.json_attributes -> 'gbl_resourceClass_sm'::text)) = 'array'::text) THEN (live_document_ids.json_attributes -> 'gbl_resourceClass_sm'::text)
                              ELSE jsonb_build_array((live_document_ids.json_attributes -> 'gbl_resourceClass_sm'::text))
                          END) AS jsonb_array_elements_text) AS "gbl_resourceClass_sm",
              ARRAY( SELECT jsonb_array_elements_text(
                          CASE
                              WHEN (((live_document_ids.json_attributes -> 'gbl_resourceType_sm'::text) IS NULL) OR ((live_document_ids.json_attributes -> 'gbl_resourceType_sm'::text) = 'null'::jsonb)) THEN '[]'::jsonb
                              WHEN (jsonb_typeof((live_document_ids.json_attributes -> 'gbl_resourceType_sm'::text)) = 'array'::text) THEN (live_document_ids.json_attributes -> 'gbl_resourceType_sm'::text)
                              ELSE jsonb_build_array((live_document_ids.json_attributes -> 'gbl_resourceType_sm'::text))
                          END) AS jsonb_array_elements_text) AS "gbl_resourceType_sm",
              ARRAY( SELECT jsonb_array_elements_text(
                          CASE
                              WHEN (((live_document_ids.json_attributes -> 'dct_subject_sm'::text) IS NULL) OR ((live_document_ids.json_attributes -> 'dct_subject_sm'::text) = 'null'::jsonb)) THEN '[]'::jsonb
                              WHEN (jsonb_typeof((live_document_ids.json_attributes -> 'dct_subject_sm'::text)) = 'array'::text) THEN (live_document_ids.json_attributes -> 'dct_subject_sm'::text)
                              ELSE jsonb_build_array((live_document_ids.json_attributes -> 'dct_subject_sm'::text))
                          END) AS jsonb_array_elements_text) AS dct_subject_sm,
              ARRAY( SELECT jsonb_array_elements_text(
                          CASE
                              WHEN (((live_document_ids.json_attributes -> 'dcat_theme_sm'::text) IS NULL) OR ((live_document_ids.json_attributes -> 'dcat_theme_sm'::text) = 'null'::jsonb)) THEN '[]'::jsonb
                              WHEN (jsonb_typeof((live_document_ids.json_attributes -> 'dcat_theme_sm'::text)) = 'array'::text) THEN (live_document_ids.json_attributes -> 'dcat_theme_sm'::text)
                              ELSE jsonb_build_array((live_document_ids.json_attributes -> 'dcat_theme_sm'::text))
                          END) AS jsonb_array_elements_text) AS dcat_theme_sm,
              ARRAY( SELECT jsonb_array_elements_text(
                          CASE
                              WHEN (((live_document_ids.json_attributes -> 'dcat_keyword_sm'::text) IS NULL) OR ((live_document_ids.json_attributes -> 'dcat_keyword_sm'::text) = 'null'::jsonb)) THEN '[]'::jsonb
                              WHEN (jsonb_typeof((live_document_ids.json_attributes -> 'dcat_keyword_sm'::text)) = 'array'::text) THEN (live_document_ids.json_attributes -> 'dcat_keyword_sm'::text)
                              ELSE jsonb_build_array((live_document_ids.json_attributes -> 'dcat_keyword_sm'::text))
                          END) AS jsonb_array_elements_text) AS dcat_keyword_sm,
              ARRAY( SELECT jsonb_array_elements_text(
                          CASE
                              WHEN (((live_document_ids.json_attributes -> 'dct_temporal_sm'::text) IS NULL) OR ((live_document_ids.json_attributes -> 'dct_temporal_sm'::text) = 'null'::jsonb)) THEN '[]'::jsonb
                              WHEN (jsonb_typeof((live_document_ids.json_attributes -> 'dct_temporal_sm'::text)) = 'array'::text) THEN (live_document_ids.json_attributes -> 'dct_temporal_sm'::text)
                              ELSE jsonb_build_array((live_document_ids.json_attributes -> 'dct_temporal_sm'::text))
                          END) AS jsonb_array_elements_text) AS dct_temporal_sm,
              (live_document_ids.json_attributes ->> 'dct_issued_s'::text) AS dct_issued_s,
              ARRAY( SELECT (jsonb_array_elements_text(
                          CASE
                              WHEN (jsonb_typeof((live_document_ids.json_attributes -> 'gbl_indexYear_im'::text)) = 'array'::text) THEN (live_document_ids.json_attributes -> 'gbl_indexYear_im'::text)
                              WHEN (jsonb_typeof((live_document_ids.json_attributes -> 'gbl_indexYear_im'::text)) = 'string'::text) THEN jsonb_build_array((live_document_ids.json_attributes -> 'gbl_indexYear_im'::text))
                              ELSE '[]'::jsonb
                          END))::integer AS jsonb_array_elements_text) AS "gbl_indexYear_im",
              ARRAY( SELECT jsonb_array_elements_text(
                          CASE
                              WHEN (((live_document_ids.json_attributes -> 'gbl_dateRange_drsim'::text) IS NULL) OR ((live_document_ids.json_attributes -> 'gbl_dateRange_drsim'::text) = 'null'::jsonb)) THEN '[]'::jsonb
                              WHEN (jsonb_typeof((live_document_ids.json_attributes -> 'gbl_dateRange_drsim'::text)) = 'array'::text) THEN (live_document_ids.json_attributes -> 'gbl_dateRange_drsim'::text)
                              ELSE jsonb_build_array((live_document_ids.json_attributes -> 'gbl_dateRange_drsim'::text))
                          END) AS jsonb_array_elements_text) AS "gbl_dateRange_drsim",
              ARRAY( SELECT jsonb_array_elements_text(
                          CASE
                              WHEN (((live_document_ids.json_attributes -> 'dct_spatial_sm'::text) IS NULL) OR ((live_document_ids.json_attributes -> 'dct_spatial_sm'::text) = 'null'::jsonb)) THEN '[]'::jsonb
                              WHEN (jsonb_typeof((live_document_ids.json_attributes -> 'dct_spatial_sm'::text)) = 'array'::text) THEN (live_document_ids.json_attributes -> 'dct_spatial_sm'::text)
                              ELSE jsonb_build_array((live_document_ids.json_attributes -> 'dct_spatial_sm'::text))
                          END) AS jsonb_array_elements_text) AS dct_spatial_sm,
              (live_document_ids.json_attributes ->> 'locn_geometry'::text) AS locn_geometry,
              (live_document_ids.json_attributes ->> 'dcat_bbox'::text) AS dcat_bbox,
              (live_document_ids.json_attributes ->> 'dcat_centroid'::text) AS dcat_centroid,
              ARRAY( SELECT DISTINCT relationship_exports.related_id
                     FROM relationship_exports
                    WHERE (((relationship_exports.document_id)::text = (live_document_ids.bridge_id)::text) AND (relationship_exports.field_name = 'dct_relation_sm'::text))
                    ORDER BY relationship_exports.related_id) AS dct_relation_sm,
              ARRAY( SELECT DISTINCT relationship_exports.related_id
                     FROM relationship_exports
                    WHERE (((relationship_exports.document_id)::text = (live_document_ids.bridge_id)::text) AND (relationship_exports.field_name = 'pcdm_memberOf_sm'::text))
                    ORDER BY relationship_exports.related_id) AS "pcdm_memberOf_sm",
              ARRAY( SELECT DISTINCT relationship_exports.related_id
                     FROM relationship_exports
                    WHERE (((relationship_exports.document_id)::text = (live_document_ids.bridge_id)::text) AND (relationship_exports.field_name = 'dct_isPartOf_sm'::text))
                    ORDER BY relationship_exports.related_id) AS "dct_isPartOf_sm",
              ARRAY( SELECT DISTINCT relationship_exports.related_id
                     FROM relationship_exports
                    WHERE (((relationship_exports.document_id)::text = (live_document_ids.bridge_id)::text) AND (relationship_exports.field_name = 'dct_source_sm'::text))
                    ORDER BY relationship_exports.related_id) AS dct_source_sm,
              ARRAY( SELECT DISTINCT relationship_exports.related_id
                     FROM relationship_exports
                    WHERE (((relationship_exports.document_id)::text = (live_document_ids.bridge_id)::text) AND (relationship_exports.field_name = 'dct_isVersionOf_sm'::text))
                    ORDER BY relationship_exports.related_id) AS "dct_isVersionOf_sm",
              ARRAY( SELECT DISTINCT relationship_exports.related_id
                     FROM relationship_exports
                    WHERE (((relationship_exports.document_id)::text = (live_document_ids.bridge_id)::text) AND (relationship_exports.field_name = 'dct_replaces_sm'::text))
                    ORDER BY relationship_exports.related_id) AS dct_replaces_sm,
              ARRAY( SELECT DISTINCT relationship_exports.related_id
                     FROM relationship_exports
                    WHERE (((relationship_exports.document_id)::text = (live_document_ids.bridge_id)::text) AND (relationship_exports.field_name = 'dct_isReplacedBy_sm'::text))
                    ORDER BY relationship_exports.related_id) AS "dct_isReplacedBy_sm",
              ARRAY( SELECT jsonb_array_elements_text(
                          CASE
                              WHEN (((live_document_ids.json_attributes -> 'dct_rights_sm'::text) IS NULL) OR ((live_document_ids.json_attributes -> 'dct_rights_sm'::text) = 'null'::jsonb)) THEN '[]'::jsonb
                              WHEN (jsonb_typeof((live_document_ids.json_attributes -> 'dct_rights_sm'::text)) = 'array'::text) THEN (live_document_ids.json_attributes -> 'dct_rights_sm'::text)
                              ELSE jsonb_build_array((live_document_ids.json_attributes -> 'dct_rights_sm'::text))
                          END) AS jsonb_array_elements_text) AS dct_rights_sm,
              ARRAY( SELECT jsonb_array_elements_text(
                          CASE
                              WHEN (((live_document_ids.json_attributes -> 'dct_rightsHolder_sm'::text) IS NULL) OR ((live_document_ids.json_attributes -> 'dct_rightsHolder_sm'::text) = 'null'::jsonb)) THEN '[]'::jsonb
                              WHEN (jsonb_typeof((live_document_ids.json_attributes -> 'dct_rightsHolder_sm'::text)) = 'array'::text) THEN (live_document_ids.json_attributes -> 'dct_rightsHolder_sm'::text)
                              ELSE jsonb_build_array((live_document_ids.json_attributes -> 'dct_rightsHolder_sm'::text))
                          END) AS jsonb_array_elements_text) AS "dct_rightsHolder_sm",
              ARRAY( SELECT jsonb_array_elements_text(
                          CASE
                              WHEN (((live_document_ids.json_attributes -> 'dct_license_sm'::text) IS NULL) OR ((live_document_ids.json_attributes -> 'dct_license_sm'::text) = 'null'::jsonb)) THEN '[]'::jsonb
                              WHEN (jsonb_typeof((live_document_ids.json_attributes -> 'dct_license_sm'::text)) = 'array'::text) THEN (live_document_ids.json_attributes -> 'dct_license_sm'::text)
                              ELSE jsonb_build_array((live_document_ids.json_attributes -> 'dct_license_sm'::text))
                          END) AS jsonb_array_elements_text) AS dct_license_sm,
              (live_document_ids.json_attributes ->> 'dct_accessRights_s'::text) AS "dct_accessRights_s",
              (live_document_ids.json_attributes ->> 'dct_format_s'::text) AS dct_format_s,
              (live_document_ids.json_attributes ->> 'gbl_fileSize_s'::text) AS "gbl_fileSize_s",
              (live_document_ids.json_attributes ->> 'gbl_wxsIdentifier_s'::text) AS "gbl_wxsIdentifier_s",
              (live_document_ids.json_attributes ->> 'dct_references_s'::text) AS dct_references_s,
              ARRAY( SELECT jsonb_array_elements_text(
                          CASE
                              WHEN (((live_document_ids.json_attributes -> 'dct_identifier_sm'::text) IS NULL) OR ((live_document_ids.json_attributes -> 'dct_identifier_sm'::text) = 'null'::jsonb)) THEN '[]'::jsonb
                              WHEN (jsonb_typeof((live_document_ids.json_attributes -> 'dct_identifier_sm'::text)) = 'array'::text) THEN (live_document_ids.json_attributes -> 'dct_identifier_sm'::text)
                              ELSE jsonb_build_array((live_document_ids.json_attributes -> 'dct_identifier_sm'::text))
                          END) AS jsonb_array_elements_text) AS dct_identifier_sm,
              (NULLIF(NULLIF((live_document_ids.json_attributes ->> 'gbl_mdModified_dt'::text), ''::text), 'null'::text))::timestamp without time zone AS "gbl_mdModified_dt",
              (live_document_ids.json_attributes ->> 'gbl_mdVersion_s'::text) AS "gbl_mdVersion_s",
              (NULLIF(NULLIF((live_document_ids.json_attributes ->> 'gbl_suppressed_b'::text), ''::text), 'null'::text))::boolean AS gbl_suppressed_b,
              (NULLIF(NULLIF((live_document_ids.json_attributes ->> 'gbl_georeferenced_b'::text), ''::text), 'null'::text))::boolean AS gbl_georeferenced_b,
              (live_document_ids.json_attributes ->> 'b1g_code_s'::text) AS b1g_code_s,
              (live_document_ids.json_attributes ->> 'b1g_status_s'::text) AS b1g_status_s,
              (live_document_ids.json_attributes ->> 'b1g_dct_accrualMethod_s'::text) AS "b1g_dct_accrualMethod_s",
              (live_document_ids.json_attributes ->> 'b1g_dct_accrualPeriodicity_s'::text) AS "b1g_dct_accrualPeriodicity_s",
              (NULLIF(NULLIF((live_document_ids.json_attributes ->> 'b1g_dateAccessioned_s'::text), ''::text), 'null'::text))::date AS "b1g_dateAccessioned_s",
              ARRAY( SELECT jsonb_array_elements_text(
                          CASE
                              WHEN (((live_document_ids.json_attributes -> 'b1g_dateAccessioned_sm'::text) IS NULL) OR ((live_document_ids.json_attributes -> 'b1g_dateAccessioned_sm'::text) = 'null'::jsonb)) THEN '[]'::jsonb
                              WHEN (jsonb_typeof((live_document_ids.json_attributes -> 'b1g_dateAccessioned_sm'::text)) = 'array'::text) THEN (live_document_ids.json_attributes -> 'b1g_dateAccessioned_sm'::text)
                              ELSE jsonb_build_array((live_document_ids.json_attributes -> 'b1g_dateAccessioned_sm'::text))
                          END) AS jsonb_array_elements_text) AS "b1g_dateAccessioned_sm",
              (NULLIF(NULLIF((live_document_ids.json_attributes ->> 'b1g_dateRetired_s'::text), ''::text), 'null'::text))::date AS "b1g_dateRetired_s",
              (NULLIF(NULLIF((live_document_ids.json_attributes ->> 'b1g_child_record_b'::text), ''::text), 'null'::text))::boolean AS b1g_child_record_b,
              ARRAY( SELECT jsonb_array_elements_text(
                          CASE
                              WHEN (((live_document_ids.json_attributes -> 'b1g_dct_mediator_sm'::text) IS NULL) OR ((live_document_ids.json_attributes -> 'b1g_dct_mediator_sm'::text) = 'null'::jsonb)) THEN '[]'::jsonb
                              WHEN (jsonb_typeof((live_document_ids.json_attributes -> 'b1g_dct_mediator_sm'::text)) = 'array'::text) THEN (live_document_ids.json_attributes -> 'b1g_dct_mediator_sm'::text)
                              ELSE jsonb_build_array((live_document_ids.json_attributes -> 'b1g_dct_mediator_sm'::text))
                          END) AS jsonb_array_elements_text) AS b1g_dct_mediator_sm,
                  CASE
                      WHEN (((live_document_ids.json_attributes -> 'b1g_access_s'::text) IS NULL) OR ((live_document_ids.json_attributes -> 'b1g_access_s'::text) = 'null'::jsonb)) THEN NULL::jsonb
                      WHEN (jsonb_typeof((live_document_ids.json_attributes -> 'b1g_access_s'::text)) = 'string'::text) THEN
                      CASE
                          WHEN (NULLIF(NULLIF((live_document_ids.json_attributes ->> 'b1g_access_s'::text), ''::text), 'null'::text) IS NULL) THEN NULL::jsonb
                          ELSE to_jsonb((live_document_ids.json_attributes ->> 'b1g_access_s'::text))
                      END
                      ELSE (live_document_ids.json_attributes -> 'b1g_access_s'::text)
                  END AS b1g_access_s,
              (live_document_ids.json_attributes ->> 'b1g_image_ss'::text) AS b1g_image_ss,
              ARRAY( SELECT jsonb_array_elements_text(
                          CASE
                              WHEN (((live_document_ids.json_attributes -> 'b1g_geonames_sm'::text) IS NULL) OR ((live_document_ids.json_attributes -> 'b1g_geonames_sm'::text) = 'null'::jsonb)) THEN '[]'::jsonb
                              WHEN (jsonb_typeof((live_document_ids.json_attributes -> 'b1g_geonames_sm'::text)) = 'array'::text) THEN (live_document_ids.json_attributes -> 'b1g_geonames_sm'::text)
                              ELSE jsonb_build_array((live_document_ids.json_attributes -> 'b1g_geonames_sm'::text))
                          END) AS jsonb_array_elements_text) AS b1g_geonames_sm,
              (live_document_ids.json_attributes ->> 'b1g_publication_state_s'::text) AS b1g_publication_state_s,
              ARRAY( SELECT jsonb_array_elements_text(
                          CASE
                              WHEN (((live_document_ids.json_attributes -> 'b1g_language_sm'::text) IS NULL) OR ((live_document_ids.json_attributes -> 'b1g_language_sm'::text) = 'null'::jsonb)) THEN '[]'::jsonb
                              WHEN (jsonb_typeof((live_document_ids.json_attributes -> 'b1g_language_sm'::text)) = 'array'::text) THEN (live_document_ids.json_attributes -> 'b1g_language_sm'::text)
                              ELSE jsonb_build_array((live_document_ids.json_attributes -> 'b1g_language_sm'::text))
                          END) AS jsonb_array_elements_text) AS b1g_language_sm,
              ARRAY( SELECT jsonb_array_elements_text(
                          CASE
                              WHEN (((live_document_ids.json_attributes -> 'b1g_creatorID_sm'::text) IS NULL) OR ((live_document_ids.json_attributes -> 'b1g_creatorID_sm'::text) = 'null'::jsonb)) THEN '[]'::jsonb
                              WHEN (jsonb_typeof((live_document_ids.json_attributes -> 'b1g_creatorID_sm'::text)) = 'array'::text) THEN (live_document_ids.json_attributes -> 'b1g_creatorID_sm'::text)
                              ELSE jsonb_build_array((live_document_ids.json_attributes -> 'b1g_creatorID_sm'::text))
                          END) AS jsonb_array_elements_text) AS "b1g_creatorID_sm",
              ARRAY( SELECT jsonb_array_elements_text(
                          CASE
                              WHEN (((live_document_ids.json_attributes -> 'b1g_dct_conformsTo_sm'::text) IS NULL) OR ((live_document_ids.json_attributes -> 'b1g_dct_conformsTo_sm'::text) = 'null'::jsonb)) THEN '[]'::jsonb
                              WHEN (jsonb_typeof((live_document_ids.json_attributes -> 'b1g_dct_conformsTo_sm'::text)) = 'array'::text) THEN (live_document_ids.json_attributes -> 'b1g_dct_conformsTo_sm'::text)
                              ELSE jsonb_build_array((live_document_ids.json_attributes -> 'b1g_dct_conformsTo_sm'::text))
                          END) AS jsonb_array_elements_text) AS "b1g_dct_conformsTo_sm",
              ARRAY( SELECT jsonb_array_elements_text(
                          CASE
                              WHEN (((live_document_ids.json_attributes -> 'b1g_dcat_spatialResolutionInMeters_sm'::text) IS NULL) OR ((live_document_ids.json_attributes -> 'b1g_dcat_spatialResolutionInMeters_sm'::text) = 'null'::jsonb)) THEN '[]'::jsonb
                              WHEN (jsonb_typeof((live_document_ids.json_attributes -> 'b1g_dcat_spatialResolutionInMeters_sm'::text)) = 'array'::text) THEN (live_document_ids.json_attributes -> 'b1g_dcat_spatialResolutionInMeters_sm'::text)
                              ELSE jsonb_build_array((live_document_ids.json_attributes -> 'b1g_dcat_spatialResolutionInMeters_sm'::text))
                          END) AS jsonb_array_elements_text) AS "b1g_dcat_spatialResolutionInMeters_sm",
              ARRAY( SELECT jsonb_array_elements_text(
                          CASE
                              WHEN (((live_document_ids.json_attributes -> 'b1g_geodcat_spatialResolutionAsText_sm'::text) IS NULL) OR ((live_document_ids.json_attributes -> 'b1g_geodcat_spatialResolutionAsText_sm'::text) = 'null'::jsonb)) THEN '[]'::jsonb
                              WHEN (jsonb_typeof((live_document_ids.json_attributes -> 'b1g_geodcat_spatialResolutionAsText_sm'::text)) = 'array'::text) THEN (live_document_ids.json_attributes -> 'b1g_geodcat_spatialResolutionAsText_sm'::text)
                              ELSE jsonb_build_array((live_document_ids.json_attributes -> 'b1g_geodcat_spatialResolutionAsText_sm'::text))
                          END) AS jsonb_array_elements_text) AS "b1g_geodcat_spatialResolutionAsText_sm",
              ARRAY( SELECT jsonb_array_elements_text(
                          CASE
                              WHEN (((live_document_ids.json_attributes -> 'b1g_dct_provenanceStatement_sm'::text) IS NULL) OR ((live_document_ids.json_attributes -> 'b1g_dct_provenanceStatement_sm'::text) = 'null'::jsonb)) THEN '[]'::jsonb
                              WHEN (jsonb_typeof((live_document_ids.json_attributes -> 'b1g_dct_provenanceStatement_sm'::text)) = 'array'::text) THEN (live_document_ids.json_attributes -> 'b1g_dct_provenanceStatement_sm'::text)
                              ELSE jsonb_build_array((live_document_ids.json_attributes -> 'b1g_dct_provenanceStatement_sm'::text))
                          END) AS jsonb_array_elements_text) AS "b1g_dct_provenanceStatement_sm",
              ARRAY( SELECT jsonb_array_elements_text(
                          CASE
                              WHEN (((live_document_ids.json_attributes -> 'b1g_adminTags_sm'::text) IS NULL) OR ((live_document_ids.json_attributes -> 'b1g_adminTags_sm'::text) = 'null'::jsonb)) THEN '[]'::jsonb
                              WHEN (jsonb_typeof((live_document_ids.json_attributes -> 'b1g_adminTags_sm'::text)) = 'array'::text) THEN (live_document_ids.json_attributes -> 'b1g_adminTags_sm'::text)
                              ELSE jsonb_build_array((live_document_ids.json_attributes -> 'b1g_adminTags_sm'::text))
                          END) AS jsonb_array_elements_text) AS "b1g_adminTags_sm",
              ARRAY( SELECT jsonb_array_elements_text(
                          CASE
                              WHEN (((live_document_ids.json_attributes -> 'b1g_adms_supportedSchema_sm'::text) IS NULL) OR ((live_document_ids.json_attributes -> 'b1g_adms_supportedSchema_sm'::text) = 'null'::jsonb)) THEN '[]'::jsonb
                              WHEN (jsonb_typeof((live_document_ids.json_attributes -> 'b1g_adms_supportedSchema_sm'::text)) = 'array'::text) THEN (live_document_ids.json_attributes -> 'b1g_adms_supportedSchema_sm'::text)
                              ELSE jsonb_build_array((live_document_ids.json_attributes -> 'b1g_adms_supportedSchema_sm'::text))
                          END) AS jsonb_array_elements_text) AS "b1g_adms_supportedSchema_sm",
              (live_document_ids.json_attributes ->> 'b1g_dcat_endpointDescription_s'::text) AS "b1g_dcat_endpointDescription_s",
              (live_document_ids.json_attributes ->> 'b1g_dcat_endpointURL_s'::text) AS "b1g_dcat_endpointURL_s",
              ARRAY( SELECT jsonb_array_elements_text(
                          CASE
                              WHEN (((live_document_ids.json_attributes -> 'b1g_dcat_inSeries_sm'::text) IS NULL) OR ((live_document_ids.json_attributes -> 'b1g_dcat_inSeries_sm'::text) = 'null'::jsonb)) THEN '[]'::jsonb
                              WHEN (jsonb_typeof((live_document_ids.json_attributes -> 'b1g_dcat_inSeries_sm'::text)) = 'array'::text) THEN (live_document_ids.json_attributes -> 'b1g_dcat_inSeries_sm'::text)
                              ELSE jsonb_build_array((live_document_ids.json_attributes -> 'b1g_dcat_inSeries_sm'::text))
                          END) AS jsonb_array_elements_text) AS "b1g_dcat_inSeries_sm",
              ARRAY( SELECT jsonb_array_elements_text(
                          CASE
                              WHEN (((live_document_ids.json_attributes -> 'b1g_localCollectionLabel_sm'::text) IS NULL) OR ((live_document_ids.json_attributes -> 'b1g_localCollectionLabel_sm'::text) = 'null'::jsonb)) THEN '[]'::jsonb
                              WHEN (jsonb_typeof((live_document_ids.json_attributes -> 'b1g_localCollectionLabel_sm'::text)) = 'array'::text) THEN (live_document_ids.json_attributes -> 'b1g_localCollectionLabel_sm'::text)
                              ELSE jsonb_build_array((live_document_ids.json_attributes -> 'b1g_localCollectionLabel_sm'::text))
                          END) AS jsonb_array_elements_text) AS "b1g_localCollectionLabel_sm",
              ARRAY( SELECT jsonb_array_elements_text(
                          CASE
                              WHEN (((live_document_ids.json_attributes -> 'b1g_prov_softwareAgent_sm'::text) IS NULL) OR ((live_document_ids.json_attributes -> 'b1g_prov_softwareAgent_sm'::text) = 'null'::jsonb)) THEN '[]'::jsonb
                              WHEN (jsonb_typeof((live_document_ids.json_attributes -> 'b1g_prov_softwareAgent_sm'::text)) = 'array'::text) THEN (live_document_ids.json_attributes -> 'b1g_prov_softwareAgent_sm'::text)
                              ELSE jsonb_build_array((live_document_ids.json_attributes -> 'b1g_prov_softwareAgent_sm'::text))
                          END) AS jsonb_array_elements_text) AS "b1g_prov_softwareAgent_sm",
              ARRAY( SELECT jsonb_array_elements_text(
                          CASE
                              WHEN (((live_document_ids.json_attributes -> 'b1g_prov_wasGeneratedBy_sm'::text) IS NULL) OR ((live_document_ids.json_attributes -> 'b1g_prov_wasGeneratedBy_sm'::text) = 'null'::jsonb)) THEN '[]'::jsonb
                              WHEN (jsonb_typeof((live_document_ids.json_attributes -> 'b1g_prov_wasGeneratedBy_sm'::text)) = 'array'::text) THEN (live_document_ids.json_attributes -> 'b1g_prov_wasGeneratedBy_sm'::text)
                              ELSE jsonb_build_array((live_document_ids.json_attributes -> 'b1g_prov_wasGeneratedBy_sm'::text))
                          END) AS jsonb_array_elements_text) AS "b1g_prov_wasGeneratedBy_sm",
              COALESCE((NULLIF(NULLIF((live_document_ids.json_attributes ->> 'date_created_dtsi'::text), ''::text), 'null'::text))::timestamp without time zone, live_document_ids.created_at) AS date_created_dtsi,
              COALESCE((NULLIF(NULLIF((live_document_ids.json_attributes ->> 'date_modified_dtsi'::text), ''::text), 'null'::text))::timestamp without time zone, live_document_ids.updated_at) AS date_modified_dtsi,
              live_document_ids.updated_at AS kithe_updated_at,
              (live_document_ids.json_attributes ->> 'geomg_id_s'::text) AS geomg_id_s,
              ARRAY( SELECT jsonb_array_elements_text(
                          CASE
                              WHEN (((live_document_ids.json_attributes -> 'b1g_adminNote_sm'::text) IS NULL) OR ((live_document_ids.json_attributes -> 'b1g_adminNote_sm'::text) = 'null'::jsonb)) THEN '[]'::jsonb
                              WHEN (jsonb_typeof((live_document_ids.json_attributes -> 'b1g_adminNote_sm'::text)) = 'array'::text) THEN (live_document_ids.json_attributes -> 'b1g_adminNote_sm'::text)
                              ELSE jsonb_build_array((live_document_ids.json_attributes -> 'b1g_adminNote_sm'::text))
                          END) AS jsonb_array_elements_text) AS "b1g_adminNote_sm",
              COALESCE((NULLIF(NULLIF((live_document_ids.json_attributes ->> 'b1g_dateAccessioned_dt'::text), ''::text), 'null'::text))::timestamp without time zone, ((NULLIF(NULLIF((live_document_ids.json_attributes ->> 'b1g_dateAccessioned_s'::text), ''::text), 'null'::text))::date)::timestamp without time zone) AS "b1g_dateAccessioned_dt",
              COALESCE((NULLIF(NULLIF((live_document_ids.json_attributes ->> 'b1g_dateRetired_dt'::text), ''::text), 'null'::text))::timestamp without time zone, ((NULLIF(NULLIF((live_document_ids.json_attributes ->> 'b1g_dateRetired_s'::text), ''::text), 'null'::text))::date)::timestamp without time zone) AS "b1g_dateRetired_dt",
              (NULLIF(NULLIF((live_document_ids.json_attributes ->> 'b1g_deprioritized_b'::text), ''::text), 'null'::text))::boolean AS b1g_deprioritized_b,
              (live_document_ids.json_attributes ->> 'b1g_harvestWorkflow_s'::text) AS "b1g_harvestWorkflow_s",
              (NULLIF(NULLIF((live_document_ids.json_attributes ->> 'b1g_isHarvested_b'::text), ''::text), 'null'::text))::boolean AS "b1g_isHarvested_b",
              (NULLIF(NULLIF((live_document_ids.json_attributes ->> 'b1g_lastHarvested_dt'::text), ''::text), 'null'::text))::timestamp without time zone AS "b1g_lastHarvested_dt",
              ARRAY( SELECT jsonb_array_elements_text(
                          CASE
                              WHEN (jsonb_typeof(COALESCE((live_document_ids.json_attributes -> 'b1g_dct_provenance_sm'::text), (live_document_ids.json_attributes -> 'b1g_dct_provenanceStatement_sm'::text))) = 'array'::text) THEN COALESCE((live_document_ids.json_attributes -> 'b1g_dct_provenance_sm'::text), (live_document_ids.json_attributes -> 'b1g_dct_provenanceStatement_sm'::text))
                              WHEN (jsonb_typeof(COALESCE((live_document_ids.json_attributes -> 'b1g_dct_provenance_sm'::text), (live_document_ids.json_attributes -> 'b1g_dct_provenanceStatement_sm'::text))) = 'string'::text) THEN jsonb_build_array(COALESCE((live_document_ids.json_attributes -> 'b1g_dct_provenance_sm'::text), (live_document_ids.json_attributes -> 'b1g_dct_provenanceStatement_sm'::text)))
                              ELSE '[]'::jsonb
                          END) AS jsonb_array_elements_text) AS b1g_dct_provenance_sm,
              COALESCE(NULLIF(NULLIF((live_document_ids.json_attributes ->> 'b1g_dcat_spatialResolutionInMeters_s'::text), ''::text), 'null'::text), NULLIF(NULLIF(((live_document_ids.json_attributes -> 'b1g_dcat_spatialResolutionInMeters_sm'::text) ->> 0), ''::text), 'null'::text)) AS "b1g_dcat_spatialResolutionInMeters_s",
              (live_document_ids.json_attributes ->> 'b1g_websitePlatform_s'::text) AS "b1g_websitePlatform_s",
              false AS deleted,
              NULL::timestamp without time zone AS deleted_at
             FROM live_document_ids
          ), deleted_documents AS (
           SELECT tombstones.friendlier_id AS id,
              tombstones.title AS dct_title_s,
              tombstones.publication_state,
              (tombstones.import_id)::character varying AS import_id,
              ARRAY[]::text[] AS dct_alternative_sm,
              ARRAY[]::text[] AS dct_description_sm,
              ARRAY[]::text[] AS dct_language_sm,
              ARRAY[]::text[] AS "gbl_displayNote_sm",
              ARRAY[]::text[] AS dct_creator_sm,
              ARRAY[]::text[] AS dct_publisher_sm,
              NULL::text AS schema_provider_s,
              ARRAY[]::text[] AS "gbl_resourceClass_sm",
              ARRAY[]::text[] AS "gbl_resourceType_sm",
              ARRAY[]::text[] AS dct_subject_sm,
              ARRAY[]::text[] AS dcat_theme_sm,
              ARRAY[]::text[] AS dcat_keyword_sm,
              ARRAY[]::text[] AS dct_temporal_sm,
              NULL::text AS dct_issued_s,
              ARRAY[]::integer[] AS "gbl_indexYear_im",
              ARRAY[]::text[] AS "gbl_dateRange_drsim",
              ARRAY[]::text[] AS dct_spatial_sm,
              NULL::text AS locn_geometry,
              NULL::text AS dcat_bbox,
              NULL::text AS dcat_centroid,
              ARRAY[]::text[] AS dct_relation_sm,
              ARRAY[]::text[] AS "pcdm_memberOf_sm",
              ARRAY[]::text[] AS "dct_isPartOf_sm",
              ARRAY[]::text[] AS dct_source_sm,
              ARRAY[]::text[] AS "dct_isVersionOf_sm",
              ARRAY[]::text[] AS dct_replaces_sm,
              ARRAY[]::text[] AS "dct_isReplacedBy_sm",
              ARRAY[]::text[] AS dct_rights_sm,
              ARRAY[]::text[] AS "dct_rightsHolder_sm",
              ARRAY[]::text[] AS dct_license_sm,
              NULL::text AS "dct_accessRights_s",
              NULL::text AS dct_format_s,
              NULL::text AS "gbl_fileSize_s",
              NULL::text AS "gbl_wxsIdentifier_s",
              NULL::text AS dct_references_s,
              ARRAY[]::text[] AS dct_identifier_sm,
              NULL::timestamp without time zone AS "gbl_mdModified_dt",
              NULL::text AS "gbl_mdVersion_s",
              NULL::boolean AS gbl_suppressed_b,
              NULL::boolean AS gbl_georeferenced_b,
              NULL::text AS b1g_code_s,
              NULL::text AS b1g_status_s,
              NULL::text AS "b1g_dct_accrualMethod_s",
              NULL::text AS "b1g_dct_accrualPeriodicity_s",
              NULL::date AS "b1g_dateAccessioned_s",
              ARRAY[]::text[] AS "b1g_dateAccessioned_sm",
              NULL::date AS "b1g_dateRetired_s",
              NULL::boolean AS b1g_child_record_b,
              ARRAY[]::text[] AS b1g_dct_mediator_sm,
              NULL::jsonb AS b1g_access_s,
              NULL::text AS b1g_image_ss,
              ARRAY[]::text[] AS b1g_geonames_sm,
              tombstones.publication_state AS b1g_publication_state_s,
              ARRAY[]::text[] AS b1g_language_sm,
              ARRAY[]::text[] AS "b1g_creatorID_sm",
              ARRAY[]::text[] AS "b1g_dct_conformsTo_sm",
              ARRAY[]::text[] AS "b1g_dcat_spatialResolutionInMeters_sm",
              ARRAY[]::text[] AS "b1g_geodcat_spatialResolutionAsText_sm",
              ARRAY[]::text[] AS "b1g_dct_provenanceStatement_sm",
              ARRAY[]::text[] AS "b1g_adminTags_sm",
              ARRAY[]::text[] AS "b1g_adms_supportedSchema_sm",
              NULL::text AS "b1g_dcat_endpointDescription_s",
              NULL::text AS "b1g_dcat_endpointURL_s",
              ARRAY[]::text[] AS "b1g_dcat_inSeries_sm",
              ARRAY[]::text[] AS "b1g_localCollectionLabel_sm",
              ARRAY[]::text[] AS "b1g_prov_softwareAgent_sm",
              ARRAY[]::text[] AS "b1g_prov_wasGeneratedBy_sm",
              NULL::timestamp without time zone AS date_created_dtsi,
              tombstones.deleted_at AS date_modified_dtsi,
              tombstones.deleted_at AS kithe_updated_at,
              tombstones.geomg_id_s,
              ARRAY[]::text[] AS "b1g_adminNote_sm",
              NULL::timestamp without time zone AS "b1g_dateAccessioned_dt",
              NULL::timestamp without time zone AS "b1g_dateRetired_dt",
              NULL::boolean AS b1g_deprioritized_b,
              NULL::text AS "b1g_harvestWorkflow_s",
              NULL::boolean AS "b1g_isHarvested_b",
              NULL::timestamp without time zone AS "b1g_lastHarvested_dt",
              ARRAY[]::text[] AS b1g_dct_provenance_sm,
              NULL::text AS "b1g_dcat_spatialResolutionInMeters_s",
              NULL::text AS "b1g_websitePlatform_s",
              true AS deleted,
              tombstones.deleted_at
             FROM kithe_bridge_deletions tombstones
            WHERE (NOT (EXISTS ( SELECT 1
                     FROM kithe_models
                    WHERE (((kithe_models.type)::text = 'Document'::text) AND ((COALESCE(kithe_models.friendlier_id, (kithe_models.id)::character varying))::text = (tombstones.friendlier_id)::text)))))
          )
   SELECT live_documents.id,
      live_documents.dct_title_s,
      live_documents.publication_state,
      live_documents.import_id,
      live_documents.dct_alternative_sm,
      live_documents.dct_description_sm,
      live_documents.dct_language_sm,
      live_documents."gbl_displayNote_sm",
      live_documents.dct_creator_sm,
      live_documents.dct_publisher_sm,
      live_documents.schema_provider_s,
      live_documents."gbl_resourceClass_sm",
      live_documents."gbl_resourceType_sm",
      live_documents.dct_subject_sm,
      live_documents.dcat_theme_sm,
      live_documents.dcat_keyword_sm,
      live_documents.dct_temporal_sm,
      live_documents.dct_issued_s,
      live_documents."gbl_indexYear_im",
      live_documents."gbl_dateRange_drsim",
      live_documents.dct_spatial_sm,
      live_documents.locn_geometry,
      live_documents.dcat_bbox,
      live_documents.dcat_centroid,
      live_documents.dct_relation_sm,
      live_documents."pcdm_memberOf_sm",
      live_documents."dct_isPartOf_sm",
      live_documents.dct_source_sm,
      live_documents."dct_isVersionOf_sm",
      live_documents.dct_replaces_sm,
      live_documents."dct_isReplacedBy_sm",
      live_documents.dct_rights_sm,
      live_documents."dct_rightsHolder_sm",
      live_documents.dct_license_sm,
      live_documents."dct_accessRights_s",
      live_documents.dct_format_s,
      live_documents."gbl_fileSize_s",
      live_documents."gbl_wxsIdentifier_s",
      live_documents.dct_references_s,
      live_documents.dct_identifier_sm,
      live_documents."gbl_mdModified_dt",
      live_documents."gbl_mdVersion_s",
      live_documents.gbl_suppressed_b,
      live_documents.gbl_georeferenced_b,
      live_documents.b1g_code_s,
      live_documents.b1g_status_s,
      live_documents."b1g_dct_accrualMethod_s",
      live_documents."b1g_dct_accrualPeriodicity_s",
      live_documents."b1g_dateAccessioned_s",
      live_documents."b1g_dateAccessioned_sm",
      live_documents."b1g_dateRetired_s",
      live_documents.b1g_child_record_b,
      live_documents.b1g_dct_mediator_sm,
      live_documents.b1g_access_s,
      live_documents.b1g_image_ss,
      live_documents.b1g_geonames_sm,
      live_documents.b1g_publication_state_s,
      live_documents.b1g_language_sm,
      live_documents."b1g_creatorID_sm",
      live_documents."b1g_dct_conformsTo_sm",
      live_documents."b1g_dcat_spatialResolutionInMeters_sm",
      live_documents."b1g_geodcat_spatialResolutionAsText_sm",
      live_documents."b1g_dct_provenanceStatement_sm",
      live_documents."b1g_adminTags_sm",
      live_documents."b1g_adms_supportedSchema_sm",
      live_documents."b1g_dcat_endpointDescription_s",
      live_documents."b1g_dcat_endpointURL_s",
      live_documents."b1g_dcat_inSeries_sm",
      live_documents."b1g_localCollectionLabel_sm",
      live_documents."b1g_prov_softwareAgent_sm",
      live_documents."b1g_prov_wasGeneratedBy_sm",
      live_documents.date_created_dtsi,
      live_documents.date_modified_dtsi,
      live_documents.kithe_updated_at,
      live_documents.geomg_id_s,
      live_documents."b1g_adminNote_sm",
      live_documents."b1g_dateAccessioned_dt",
      live_documents."b1g_dateRetired_dt",
      live_documents.b1g_deprioritized_b,
      live_documents."b1g_harvestWorkflow_s",
      live_documents."b1g_isHarvested_b",
      live_documents."b1g_lastHarvested_dt",
      live_documents.b1g_dct_provenance_sm,
      live_documents."b1g_dcat_spatialResolutionInMeters_s",
      live_documents."b1g_websitePlatform_s",
      live_documents.deleted,
      live_documents.deleted_at
     FROM live_documents
  UNION ALL
   SELECT deleted_documents.id,
      deleted_documents.dct_title_s,
      deleted_documents.publication_state,
      deleted_documents.import_id,
      deleted_documents.dct_alternative_sm,
      deleted_documents.dct_description_sm,
      deleted_documents.dct_language_sm,
      deleted_documents."gbl_displayNote_sm",
      deleted_documents.dct_creator_sm,
      deleted_documents.dct_publisher_sm,
      deleted_documents.schema_provider_s,
      deleted_documents."gbl_resourceClass_sm",
      deleted_documents."gbl_resourceType_sm",
      deleted_documents.dct_subject_sm,
      deleted_documents.dcat_theme_sm,
      deleted_documents.dcat_keyword_sm,
      deleted_documents.dct_temporal_sm,
      deleted_documents.dct_issued_s,
      deleted_documents."gbl_indexYear_im",
      deleted_documents."gbl_dateRange_drsim",
      deleted_documents.dct_spatial_sm,
      deleted_documents.locn_geometry,
      deleted_documents.dcat_bbox,
      deleted_documents.dcat_centroid,
      deleted_documents.dct_relation_sm,
      deleted_documents."pcdm_memberOf_sm",
      deleted_documents."dct_isPartOf_sm",
      deleted_documents.dct_source_sm,
      deleted_documents."dct_isVersionOf_sm",
      deleted_documents.dct_replaces_sm,
      deleted_documents."dct_isReplacedBy_sm",
      deleted_documents.dct_rights_sm,
      deleted_documents."dct_rightsHolder_sm",
      deleted_documents.dct_license_sm,
      deleted_documents."dct_accessRights_s",
      deleted_documents.dct_format_s,
      deleted_documents."gbl_fileSize_s",
      deleted_documents."gbl_wxsIdentifier_s",
      deleted_documents.dct_references_s,
      deleted_documents.dct_identifier_sm,
      deleted_documents."gbl_mdModified_dt",
      deleted_documents."gbl_mdVersion_s",
      deleted_documents.gbl_suppressed_b,
      deleted_documents.gbl_georeferenced_b,
      deleted_documents.b1g_code_s,
      deleted_documents.b1g_status_s,
      deleted_documents."b1g_dct_accrualMethod_s",
      deleted_documents."b1g_dct_accrualPeriodicity_s",
      deleted_documents."b1g_dateAccessioned_s",
      deleted_documents."b1g_dateAccessioned_sm",
      deleted_documents."b1g_dateRetired_s",
      deleted_documents.b1g_child_record_b,
      deleted_documents.b1g_dct_mediator_sm,
      deleted_documents.b1g_access_s,
      deleted_documents.b1g_image_ss,
      deleted_documents.b1g_geonames_sm,
      deleted_documents.b1g_publication_state_s,
      deleted_documents.b1g_language_sm,
      deleted_documents."b1g_creatorID_sm",
      deleted_documents."b1g_dct_conformsTo_sm",
      deleted_documents."b1g_dcat_spatialResolutionInMeters_sm",
      deleted_documents."b1g_geodcat_spatialResolutionAsText_sm",
      deleted_documents."b1g_dct_provenanceStatement_sm",
      deleted_documents."b1g_adminTags_sm",
      deleted_documents."b1g_adms_supportedSchema_sm",
      deleted_documents."b1g_dcat_endpointDescription_s",
      deleted_documents."b1g_dcat_endpointURL_s",
      deleted_documents."b1g_dcat_inSeries_sm",
      deleted_documents."b1g_localCollectionLabel_sm",
      deleted_documents."b1g_prov_softwareAgent_sm",
      deleted_documents."b1g_prov_wasGeneratedBy_sm",
      deleted_documents.date_created_dtsi,
      deleted_documents.date_modified_dtsi,
      deleted_documents.kithe_updated_at,
      deleted_documents.geomg_id_s,
      deleted_documents."b1g_adminNote_sm",
      deleted_documents."b1g_dateAccessioned_dt",
      deleted_documents."b1g_dateRetired_dt",
      deleted_documents.b1g_deprioritized_b,
      deleted_documents."b1g_harvestWorkflow_s",
      deleted_documents."b1g_isHarvested_b",
      deleted_documents."b1g_lastHarvested_dt",
      deleted_documents.b1g_dct_provenance_sm,
      deleted_documents."b1g_dcat_spatialResolutionInMeters_s",
      deleted_documents."b1g_websitePlatform_s",
      deleted_documents.deleted,
      deleted_documents.deleted_at
     FROM deleted_documents;
  SQL
  add_index "kithe_to_resources_bridge", ["id"], name: "kithe_to_resources_bridge_id_uidx", unique: true

end

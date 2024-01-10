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

ActiveRecord::Schema[7.0].define(version: 2024_01_10_161003) do
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
    t.string "field_name"
    t.string "field_value"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "action_type", default: "ChangePublicationState", null: false
    t.string "action"
  end

  create_table "document_accesses", force: :cascade do |t|
    t.string "friendlier_id", null: false
    t.string "institution_code", null: false
    t.text "access_url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "document_downloads", force: :cascade do |t|
    t.string "friendlier_id"
    t.string "label"
    t.string "value"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "good_job_batches", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.jsonb "serialized_properties"
    t.text "on_finish"
    t.text "on_success"
    t.text "on_discard"
    t.text "callback_queue_name"
    t.integer "callback_priority"
    t.datetime "enqueued_at", precision: nil
    t.datetime "discarded_at", precision: nil
    t.datetime "finished_at", precision: nil
  end

  create_table "good_job_executions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "active_job_id", null: false
    t.text "job_class"
    t.text "queue_name"
    t.jsonb "serialized_params"
    t.datetime "scheduled_at", precision: nil
    t.datetime "finished_at", precision: nil
    t.text "error"
    t.integer "error_event", limit: 2
    t.index ["active_job_id", "created_at"], name: "index_good_job_executions_on_active_job_id_and_created_at"
  end

  create_table "good_job_processes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "state"
  end

  create_table "good_job_settings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "key"
    t.jsonb "value"
    t.index ["key"], name: "index_good_job_settings_on_key", unique: true
  end

  create_table "good_jobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "queue_name"
    t.integer "priority"
    t.jsonb "serialized_params"
    t.datetime "scheduled_at", precision: nil
    t.datetime "performed_at", precision: nil
    t.datetime "finished_at", precision: nil
    t.text "error"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "active_job_id"
    t.text "concurrency_key"
    t.text "cron_key"
    t.uuid "retried_good_job_id"
    t.datetime "cron_at", precision: nil
    t.uuid "batch_id"
    t.uuid "batch_callback_id"
    t.boolean "is_discrete"
    t.integer "executions_count"
    t.text "job_class"
    t.integer "error_event", limit: 2
    t.index ["active_job_id", "created_at"], name: "index_good_jobs_on_active_job_id_and_created_at"
    t.index ["active_job_id"], name: "index_good_jobs_on_active_job_id"
    t.index ["batch_callback_id"], name: "index_good_jobs_on_batch_callback_id", where: "(batch_callback_id IS NOT NULL)"
    t.index ["batch_id"], name: "index_good_jobs_on_batch_id", where: "(batch_id IS NOT NULL)"
    t.index ["concurrency_key"], name: "index_good_jobs_on_concurrency_key_when_unfinished", where: "(finished_at IS NULL)"
    t.index ["cron_key", "created_at"], name: "index_good_jobs_on_cron_key_and_created_at"
    t.index ["cron_key", "cron_at"], name: "index_good_jobs_on_cron_key_and_cron_at", unique: true
    t.index ["finished_at"], name: "index_good_jobs_jobs_on_finished_at", where: "((retried_good_job_id IS NULL) AND (finished_at IS NOT NULL))"
    t.index ["priority", "created_at"], name: "index_good_jobs_jobs_on_priority_created_at_when_unfinished", order: { priority: "DESC NULLS LAST" }, where: "(finished_at IS NULL)"
    t.index ["queue_name", "scheduled_at"], name: "index_good_jobs_on_queue_name_and_scheduled_at", where: "(finished_at IS NULL)"
    t.index ["scheduled_at"], name: "index_good_jobs_on_scheduled_at", where: "(finished_at IS NULL)"
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
end

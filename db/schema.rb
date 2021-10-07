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

ActiveRecord::Schema.define(version: 2021_10_06_201348) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.integer "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "bookmarks", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "user_type"
    t.string "document_id"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "document_type"
    t.index ["user_id"], name: "index_bookmarks_on_user_id"
  end

  create_table "image_upload_transitions", force: :cascade do |t|
    t.string "to_state", null: false
    t.text "metadata"
    t.integer "sort_key", null: false
    t.integer "solr_document_sidecar_id"
    t.boolean "most_recent", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["solr_document_sidecar_id", "sort_key"], name: "index_image_upload_transitions_parent_sort", unique: true
    t.index ["solr_document_sidecar_id"], name: "index_image_upload_transitions_on_solr_document_sidecar_id"
  end

  create_table "pointless_feedback_messages", force: :cascade do |t|
    t.string "name"
    t.string "email_address"
    t.string "topic"
    t.text "description"
    t.text "previous_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "searches", force: :cascade do |t|
    t.text "query_params"
    t.integer "user_id"
    t.string "user_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_searches_on_user_id"
  end

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

  create_table "solr_document_sidecars", force: :cascade do |t|
    t.string "document_id"
    t.string "document_type"
    t.string "cw_image"
    t.integer "version", limit: 8
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document_type", "document_id"], name: "solr_document_sidecars_solr_document"
  end

  create_table "solr_document_uris", force: :cascade do |t|
    t.string "document_id"
    t.string "document_type"
    t.string "uri_key"
    t.string "uri_value"
    t.integer "version", limit: 8
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document_type", "document_id"], name: "solr_document_uris_solr_document"
  end

  create_table "uri_transitions", force: :cascade do |t|
    t.string "to_state", null: false
    t.text "metadata"
    t.integer "sort_key", null: false
    t.integer "solr_document_uri_id"
    t.boolean "most_recent", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["solr_document_uri_id", "sort_key"], name: "index_uri_transitions_parent_sort", unique: true
    t.index ["solr_document_uri_id"], name: "index_uri_transitions_on_solr_document_uri_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "guest", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "image_upload_transitions", "solr_document_sidecars"
  add_foreign_key "uri_transitions", "solr_document_uris"
end

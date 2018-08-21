# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180627150806) do

  create_table "bookmarks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id", null: false
    t.string "user_type"
    t.string "document_id"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "document_type"
    t.index ["user_id"], name: "index_bookmarks_on_user_id"
  end

  create_table "image_upload_transitions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
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

  create_table "pointless_feedback_messages", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "email_address"
    t.string "topic"
    t.text "description"
    t.text "previous_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "searches", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text "query_params"
    t.integer "user_id"
    t.string "user_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_searches_on_user_id"
  end

  create_table "solr_document_sidecars", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "document_id"
    t.string "document_type"
    t.string "image"
    t.bigint "version"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document_type", "document_id"], name: "solr_document_sidecars_solr_document"
  end

  create_table "solr_document_uris", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "document_id"
    t.string "document_type"
    t.string "uri_key"
    t.string "uri_value"
    t.bigint "version"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document_type", "document_id"], name: "solr_document_uris_solr_document"
  end

  create_table "uri_transitions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
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

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
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

  add_foreign_key "image_upload_transitions", "solr_document_sidecars"
  add_foreign_key "uri_transitions", "solr_document_uris"
end

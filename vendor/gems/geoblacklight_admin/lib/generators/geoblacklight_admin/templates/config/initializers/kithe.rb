# frozen_string_literal: true

require "simple_form"
require "kithe"

traject_logger = ActiveSupport::Logger.new("#{Rails.root}/log/traject.log")

Kithe.indexable_settings.solr_url = ENV["SOLR_URL"]

# Index to solr with solr `id` field being our friendlier_id
Kithe.indexable_settings.solr_id_value_attribute = :friendlier_id

# Traject settings
Kithe.indexable_settings.writer_settings.merge!({
  "solr_writer.thread_pool" => 0,
  "solr_writer.batch_size" => 1,
  "solr_writer.solr_update_args" => {softCommit: true},
  "solr_writer.http_timeout" => 3,
  "solr_writer.max_skipped" => -1,
  "logger" => traject_logger
})

# Traject with Basic Auth support
if ENV["SOLR_BASIC_AUTH_USER"].present?
  Kithe.indexable_settings.writer_settings.merge!({
    "solr_writer.basic_auth_user" => ENV["SOLR_BASIC_AUTH_USER"],
    "solr_writer.basic_auth_password" => ENV["SOLR_BASIC_AUTH_PASSWORD"],
    "solr_writer.thread_pool" => 0,
    "solr_writer.batch_size" => 1,
    "solr_writer.solr_update_args" => {softCommit: true}, "solr_writer.http_timeout" => 3,
    "solr_writer.max_skipped" => -1,
    "logger" => traject_logger
  })
end

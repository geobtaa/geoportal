# frozen_string_literal: true

require "json"

GEOMG_SCHEMA = HashWithIndifferentAccess.new(
  JSON.parse(
    File.read(
      Rails.root.join("config/geomg_aardvark_schema.json")
    )
  )
)

# GEOMG_SCHEMA_TIMESTAMP
# This constant hold the Time of the last changes to the Element table.
# If the timestamp changes, the rails server and sidekiq will need to be restarted.
unless File.exist?(Rails.root.join("tmp/schema_timestamp.txt").to_s)
  File.write(Rails.root.join("tmp/schema_timestamp.txt").to_s, Time.now.to_s)
end
GEOMG_SCHEMA_TIMESTAMP = File.read(Rails.root.join("tmp/schema_timestamp.txt").to_s)

BLACKLIGHT_URL = ENV["BLACKLIGHT_URL"]
BLACKLIGHT_JSON_API = ENV["BLACKLIGHT_JSON_API"]
BLACKLIGHT_JSON_API_IDS = ENV["BLACKLIGHT_JSON_API_IDS"]
BLACKLIGHT_JSON_API_FACETS = ENV["BLACKLIGHT_JSON_API_FACETS"]

# Former Controller > Concern
module Admin
  module UploadUtil
    def self.kithe_upload_data_config(toggle_value: "kithe-upload")
      {
        toggle: toggle_value,
        upload_endpoint: Rails.application.routes.url_helpers.admin_direct_app_upload_path
      }
    end
  end
end

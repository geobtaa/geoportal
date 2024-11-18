# frozen_string_literal: true

# Solr indexing for our Geoname class.
class GeonameIndexer < Kithe::Indexer

  traject_logger = ActiveSupport::Logger.new("#{Rails.root}/log/traject.log")

  # Uses a geonames solr core
  Kithe.indexable_settings.solr_url = "http://localhost:8983/solr/geonames"

  # Traject settings
  Kithe.indexable_settings.writer_settings.merge!({
    "solr_writer.thread_pool" => 0,
    "solr_writer.batch_size" => 1,
    "solr_writer.solr_update_args" => {softCommit: true},
    "solr_writer.http_timeout" => 3,
    "solr_writer.max_skipped" => 0,
    "logger" => traject_logger
  })

  # Configure fields
  configure do
    to_field "geonameid_i", obj_extract("geonameid")
    to_field "name_s", obj_extract("name")
    to_field "asciiname_s", obj_extract("asciiname")
    to_field "alternatename_ss", obj_extract("alternatenames") do |rec, acc|
      acc << rec.alternatenames.split(',') if rec&.alternatenames
    end
    to_field "latitude", obj_extract("latitude")
    to_field "longitude", obj_extract("longitude")
    to_field "feature_class_s", obj_extract("feature_class")
    to_field "feature_code_s", obj_extract("feature_code")
    to_field "country_code_s", obj_extract("country_code")
    to_field "cc2_s", obj_extract("cc2")
    to_field "admin1_code_s", obj_extract("admin1_code")
    to_field "admin2_code_s", obj_extract("admin2_code")
    to_field "admin3_code_s", obj_extract("admin3_code")
    to_field "admin4_code_s", obj_extract("admin4_code")
    to_field "population_i", obj_extract("population")
    to_field "elevation_i", obj_extract("elevation")
    to_field "dem_i", obj_extract("dem")
    to_field "timezone_s", obj_extract("timezone")
    to_field "modification_date_s", obj_extract("modification_date")
    to_field "location_p" do |rec, acc|
      acc << "#{rec.latitude},#{rec.longitude}" if rec&.latitude && rec&.longitude
    end

    to_field "date_created_dtsi" do |rec, _acc|
      rec.created_at.utc.iso8601 if rec&.created_at
    end

    to_field "date_modified_dtsi" do |rec, _acc|
      rec.updated_at.utc.iso8601 if rec&.updated_at
    end
  end
end

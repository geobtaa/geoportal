# Development can use the local file system or S3 for storage
# Production uses S3 for storage
# See: /var/www/geoportal/shared/config/initalizers/shrine.rb

require "shrine"

if ENV["SHRINE_S3_STORAGE"].present?
  require "shrine/storage/s3"

  s3_options = {
    bucket: ENV["SHRINE_S3_BUCKET"],
    region: ENV["SHRINE_AWS_REGION"],
    access_key_id: ENV["SHRINE_AWS_ACCESS_KEY_ID"],
    secret_access_key: ENV["SHRINE_AWS_SECRET_ACCESS_KEY"]
  }
  
  Shrine.storages = {
    cache: Shrine::Storage::S3.new(public: true, prefix: "cache", **s3_options),
    store: Shrine::Storage::S3.new(public: true, prefix: "store", **s3_options),
    kithe_derivatives: Shrine::Storage::S3.new(public: true, prefix: "kithe_derivatives", **s3_options)
  }
  
  Shrine.plugin :upload_endpoint
  Shrine.plugin :cached_attachment_data # for retaining the cached file across form redisplays
  Shrine.plugin :restore_cached_data # re-extract metadata when attaching a cached file
else
  require "shrine/storage/file_system"

  Shrine.storages = {
    cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"),          # temporary
    store: Shrine::Storage::FileSystem.new("public", prefix: "uploads"),                # permanent
    kithe_derivatives: Shrine::Storage::FileSystem.new("public", prefix: "derivatives") # permanent
  }

  Shrine.plugin :activerecord
  Shrine.plugin :upload_endpoint
  Shrine.plugin :cached_attachment_data # for retaining the cached file across form redisplays
  Shrine.plugin :restore_cached_data # re-extract metadata when attaching a cached file
end
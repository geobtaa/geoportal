# Local Development uses the file system for storage
# Production uses S3 for storage
# See: /var/www/geoportal/shared/config/initalizers/shrine.rb

require "shrine"
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

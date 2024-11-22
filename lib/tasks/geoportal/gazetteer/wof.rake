require 'bzip2/ffi'
require 'csv'
require 'fileutils'
require 'open-uri'
require 'rsolr'

# Geoportal Gazetteer Who's on First Tasks
# Order of execution: 
# 1. download
# 2. import (todo)
namespace :geoportal do
  namespace :gazetteer do
    namespace :wof do
      desc "Download Who's on First sqlite3 database"
      task download: :environment do
        url = 'https://data.geocode.earth/wof/dist/sqlite/whosonfirst-data-admin-us-latest.db.bz2'
        file_path = Rails.root.join('db', 'gazetteer', 'wof', 'whosonfirst-data-admin-us-latest.db.bz2')
        extract_path = Rails.root.join('db', 'gazetteer', 'wof')

        # Ensure the directory exists
        FileUtils.mkdir_p(extract_path)

        # Download the zip file 
        begin
          puts "Downloading file from #{url}..."
          URI.open(url) do |remote_file|
            File.open(file_path, 'wb') do |file|
            file.write(remote_file.read)
            end
          end
        rescue OpenURI::HTTPError => e
          puts "Failed to download file: #{e.message}"
          return
        rescue Errno::ENOENT => e
          puts "Error accessing URL: #{e.message}"
          return
        end

        # Extract the bz2 file and write the decompressed content to a .db file
        Bzip2::FFI::Reader.open(file_path) do |input|
          File.open(File.join(extract_path, 'whosonfirst-data-admin-us-latest.db'), 'wb') do |output|
            IO.copy_stream(input, output)
          end
        end

        puts "Download and extraction completed successfully."
      end

      desc "Import Who's on First data into Rails"
      task import: :environment do
        # todo
      end
    end
  end
end
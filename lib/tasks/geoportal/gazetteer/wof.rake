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
        url = 'https://data.geocode.earth/wof/dist/bundles/whosonfirst-data-admin-us-latest.tar.bz2'
        zip_path = Rails.root.join('db', 'gazetteer', 'wof', 'whosonfirst-data-admin-us-latest.tar.bz2')
        extract_path = Rails.root.join('db', 'gazetteer', 'wof')

        # Ensure the directory exists
        FileUtils.mkdir_p(extract_path)

        # Download the zip file 
        begin
          puts "Downloading file from #{url}..."
          URI.open(url) do |remote_file|
            File.open(zip_path, 'wb') do |file|
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

        # Extract the bz2 file
        Bzip2::FFI::Reader.open(zip_path) do |input|
          File.open(File.join(extract_path, 'whosonfirst-data-admin-us-latest.tar'), 'wb') do |output|
            IO.copy_stream(input, output)
          end
        end

        # Optionally, extract the tar file if needed
        system("tar -xvf #{File.join(extract_path, 'whosonfirst-data-admin-us-latest.tar')} -C #{extract_path}")

        puts "Download and extraction completed successfully."
      end

      desc "Import Who's on First data into Rails"
      task import: :environment do
        # todo
      end
    end
  end
end
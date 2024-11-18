require 'csv'
require 'open-uri'
require 'zip'
require 'fileutils'
require 'rsolr'

namespace :geoportal do
  namespace :geonames do
    desc "Download and extract allCountries.zip from Geonames"
    task download: :environment do
      # Takes a day to process
      # url = 'https://download.geonames.org/export/dump/allCountries.zip'
      # zip_path = Rails.root.join('db', 'geonames', 'allCountries.zip')
      
      # Takes 
      url = 'https://download.geonames.org/export/dump/US.zip'
      zip_path = Rails.root.join('db', 'geonames', 'US.zip')
      extract_path = Rails.root.join('db', 'geonames')

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

      # Extract the zip file
      Zip::File.open(zip_path) do |zip_file|
        zip_file.each do |entry|
          entry.extract(File.join(extract_path, entry.name)) { true }
        end
      end

      puts "Download and extraction completed successfully."
    end

    desc "Import allCountries.txt data into the Geonames table"
    task import: :environment do
      file_path = Rails.root.join('db', 'geonames', 'US.txt')

      # Check if the file exists
      unless File.exist?(file_path)
        puts "File not found. Downloading..."
        Rake::Task['geoportal:geonames:download'].invoke
      end

      # Geonames Array
      geonames = []

      # Count the total number of lines in the file
      total_lines = `wc -l "#{file_path}"`.strip.split(' ')[0].to_i

      # Initialize the progress bar
      progress_bar = ProgressBar.create(total: total_lines, format: "%a %b\u{15E7}%i %p%% %t")

      File.open(file_path, 'r') do |f|
        until f.eof?
          begin
            text = f.readline
            row = CSV.parse_line(text, col_sep: "\t", headers: false)
            geonames << {
              geonameid: row[0],
              name: row[1],
              asciiname: row[2],
              alternatenames: row[3],
              latitude: row[4],
              longitude: row[5],
              feature_class: row[6],
              feature_code: row[7],
              country_code: row[8],
              cc2: row[9],
              admin1_code: row[10],
              admin2_code: row[11],
              admin3_code: row[12],
              admin4_code: row[13],
              population: row[14],
              elevation: row[15],
              dem: row[16],
              timezone: row[17],
              modification_date: row[18]
            }

            # Import every 100000 records
            if geonames.size >= 100000
              Geoname.import(geonames, validate: false)
              geonames.clear
            end

            # Increment the progress bar
            progress_bar.increment
          rescue StandardError => e
            puts "Error processing line: #{e.message}"
          end
        end
      end

      # Import any remaining records
      Geoname.import(geonames, validate: false) unless geonames.empty?

      puts "Geonames import completed successfully."
    end

    desc "Import Geoname entries into Solr"
    task reindex_solr: :environment do
      # Define the path to the CSV file
      csv_file_path = Rails.root.join('db', 'geonames', 'geonames_export.csv')

      # Define the Solr update URL
      solr_url = "http://localhost:8983/solr/geonames/update?commit=true"

      # Execute the curl command to update Solr
      begin
        puts "Updating Solr with data from #{csv_file_path}..."
        system("curl '#{solr_url}' --data-binary @#{csv_file_path} -H 'Content-type:application/csv'")
        puts "Geonames import to Solr completed successfully."
      rescue StandardError => e
        puts "Error updating Solr: #{e.message}"
      end
    end

    desc "Export Geoname table to a CSV file using PostgreSQL COPY"
    task export: :environment do
      file_path = Rails.root.join('db', 'geonames', 'geonames_export.csv')

      # Execute the COPY command
      begin
        connection = ActiveRecord::Base.connection
        connection.execute <<-SQL
          COPY (
            SELECT 
              geonameid, 
              name AS name_s, 
              asciiname AS asciiname_s, 
              alternatenames AS alternatenames_s, 
              latitude AS latitude_f, 
              longitude AS longitude_f,
              feature_class AS feature_class_s, 
              feature_code AS feature_code_s, 
              country_code AS country_code_s, 
              cc2 AS cc2_s, 
              admin1_code AS admin1_code_s,
              admin2_code AS admin2_code_s, 
              admin3_code AS admin3_code_s, 
              admin4_code AS admin4_code_s, 
              population AS population_i, 
              elevation AS elevation_i,
              dem AS dem_i, 
              timezone AS timezone_s, 
              modification_date AS modification_date_dts,
              latitude || ',' || longitude AS location_p
            FROM geonames
          )
          TO '#{file_path}' WITH CSV HEADER;
        SQL

        puts "Geoname table exported to #{file_path} successfully using PostgreSQL COPY."
      rescue StandardError => e
        puts "Error exporting Geoname table: #{e.message}"
      end
    end
  end
end

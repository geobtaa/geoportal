require 'bzip2/ffi'
require 'csv'
require 'fileutils'
require 'open-uri'
require 'rsolr'
require 'sqlite3'

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

      # Imports the data, but some is duplicated from the import above.
      desc "Export SQLite tables to CSV and import into PostgreSQL"
      task import: :environment do
        file_path = Rails.root.join('db', 'gazetteer', 'wof', 'whosonfirst-data-admin-us-latest.db')
        csv_dir = Rails.root.join('db', 'gazetteer', 'wof', 'csv')
        FileUtils.mkdir_p(csv_dir)
   
        puts "Exporting SQLite tables to CSV from #{file_path}..."

        # Open the SQLite database
        db = SQLite3::Database.new(file_path.to_s)

        # Get the list of tables
        tables = db.execute("SELECT name FROM sqlite_master WHERE type='table';").flatten

        # Export each table to a CSV file
        tables.each do |table|
          csv_file = File.join(csv_dir, "#{table}.csv")
          CSV.open(csv_file, 'wb') do |csv|
            db.execute2("SELECT * FROM #{table};") do |row|
              csv << row
            end
          end
          puts "Exported #{table} to #{csv_file}"
        end

        # Call the individual import tasks
        Rake::Task['geoportal:gazetteer:wof:import_ancestors'].invoke
        Rake::Task['geoportal:gazetteer:wof:import_concordances'].invoke
        Rake::Task['geoportal:gazetteer:wof:import_geojson'].invoke
        Rake::Task['geoportal:gazetteer:wof:import_names'].invoke
        Rake::Task['geoportal:gazetteer:wof:import_spr'].invoke
        puts "CSV export and import completed successfully."
      end

      desc "Import Ancestors CSV file into PostgreSQL"
      task import_ancestors: :environment do
        file_path = Rails.root.join('db', 'gazetteer', 'wof', 'csv', 'gazetteer_wof_ancestors.csv')

        # Check if the file exists
        unless File.exist?(file_path)
          puts "File not found. Downloading..."
          Rake::Task['geoportal:gazetteer:wof:download'].invoke
        end

        # Geonames Array
        ancestors = []

        # Count the total number of lines in the file
        total_lines = `wc -l "#{file_path}"`.strip.split(' ')[0].to_i

        # Initialize the progress bar
        progress_bar = ProgressBar.create(total: total_lines, format: "%a %b\u{15E7}%i %p%% %t")

        # Open the file
        File.open(file_path, 'r') do |f|
          until f.eof?
            begin
              text = f.readline
              row = CSV.parse_line(text, headers: false)
              
              # Ancestor Table Schema
              # t.bigint :wok_id
              # t.integer :ancestor_id
              # t.string :ancestor_placetype
              # t.integer :lastmodified
              ancestors << {
                wok_id: row[0].to_i,
                ancestor_id: row[1].to_i,
                ancestor_placetype: row[2].to_s,
                lastmodified: row[3].to_i,
              }

              # Import every 100000 records
              if ancestors.size >= 100000
                Gazetteer::Wof::Ancestor.import(ancestors, validate: false)
                ancestors.clear
              end
              
              # Increment the progress bar
              progress_bar.increment
            rescue StandardError => e
              puts "Error processing line: #{e.message}"
            end
          end
        end

        # Import any remaining records
        Gazetteer::Wof::Ancestor.import(ancestors, validate: false) unless ancestors.empty?

        puts "Imported ancestors from #{file_path} into PostgreSQL"
      end

      desc "Import Concordances CSV file into PostgreSQL"
      task import_concordances: :environment do
        file_path = Rails.root.join('db', 'gazetteer', 'wof', 'csv', 'gazetteer_wof_concordances.csv')

        # Check if the file exists
        unless File.exist?(file_path)
          puts "File not found. Downloading..."
          Rake::Task['geoportal:gazetteer:wof:download'].invoke
        end

        # Concordances Array
        concordances = []

        # Count the total number of lines in the file
        total_lines = `wc -l "#{file_path}"`.strip.split(' ')[0].to_i

        # Initialize the progress bar
        progress_bar = ProgressBar.create(total: total_lines, format: "%a %b\u{15E7}%i %p%% %t")

        # Open the file
        File.open(file_path, 'r') do |f|
          until f.eof?
            begin
              text = f.readline
              row = CSV.parse_line(text, headers: false)

              # Concordance Table Schema
              # t.bigint :wok_id
              # t.string :other_id
              # t.string :other_source
              # t.integer :lastmodified
              concordances << {
                wok_id: row[0].to_i,
                other_id: begin
                  id = row[1].to_s
                  id.end_with?('.0') ? id.chomp('.0') : id
                end,
                other_source: row[2].to_s,
                lastmodified: row[3].to_i,
              }

              # Import every 100000 records
              if concordances.size >= 100000
                Gazetteer::Wof::Concordance.import(concordances, validate: false)
                concordances.clear
              end
              
              # Increment the progress bar
              progress_bar.increment
            rescue StandardError => e
              puts "Error processing line: #{e.message}"
            end
          end
        end

        # Import any remaining records
        Gazetteer::Wof::Concordance.import(concordances, validate: false) unless concordances.empty?

        puts "Imported concordances from #{file_path} into PostgreSQL"
      end

      desc "Import GeoJSON CSV file into PostgreSQL"
      task import_geojson: :environment do
        file_path = Rails.root.join('db', 'gazetteer', 'wof', 'csv', 'gazetteer_wof_geojson.csv')

        # Check if the file exists
        unless File.exist?(file_path)
          puts "File not found. Downloading..."
          Rake::Task['geoportal:gazetteer:wof:download'].invoke
        end

        # GeoJSON Array
        geojson_records = []

        # Count the total number of lines in the file
        total_lines = `wc -l "#{file_path}"`.strip.split(' ')[0].to_i

        # Initialize the progress bar
        progress_bar = ProgressBar.create(total: total_lines, format: "%a %b\u{15E7}%i %p%% %t")

        # Open the file
        File.open(file_path, 'r') do |f|
          until f.eof?
            begin
              text = f.readline
              row = CSV.parse_line(text, headers: false)

              # GeoJSON Table Schema
              # t.bigint :wok_id
              # t.text :body
              # t.string :source
              # t.string :alt_label
              # t.boolean :is_alt
              # t.integer :lastmodified
              geojson_records << {
                wok_id: row[0].to_i,
                body: row[1].to_s,
                source: row[2].to_s,
                alt_label: row[3].to_s,
                is_alt: row[4] == 'true',
                lastmodified: row[5].to_i,
              }

              # Import every 100000 records
              if geojson_records.size >= 100000
                Gazetteer::Wof::Geojson.import(geojson_records, validate: false)
                geojson_records.clear
              end
              
              # Increment the progress bar
              progress_bar.increment
            rescue StandardError => e
              puts "Error processing line: #{e.message}"
            end
          end
        end

        # Import any remaining records
        Gazetteer::Wof::Geojson.import(geojson_records, validate: false) unless geojson_records.empty?

        puts "Imported geojson records from #{file_path} into PostgreSQL"
      end

      desc "Import Names CSV file into PostgreSQL"
      task import_names: :environment do
        file_path = Rails.root.join('db', 'gazetteer', 'wof', 'csv', 'gazetteer_wof_names.csv')

        # Check if the file exists
        unless File.exist?(file_path)
          puts "File not found. Downloading..."
          Rake::Task['geoportal:gazetteer:wof:download'].invoke
        end

        # Names Array
        names_records = []

        # Count the total number of lines in the file
        total_lines = `wc -l "#{file_path}"`.strip.split(' ')[0].to_i

        # Initialize the progress bar
        progress_bar = ProgressBar.create(total: total_lines, format: "%a %b\u{15E7}%i %p%% %t")

        # Open the file
        File.open(file_path, 'r') do |f|
          until f.eof?
            begin
              text = f.readline
              row = CSV.parse_line(text, headers: false)

              # Names Table Schema
              # t.bigint :wok_id
              # t.string :placetype
              # t.string :country
              # t.string :language
              # t.string :extlang
              # t.string :script
              # t.string :region
              # t.string :variant
              # t.string :extension
              # t.string :privateuse
              # t.string :name
              # t.integer :lastmodified
              names_records << {
                wok_id: row[0].to_i,
                placetype: row[1].to_s,
                country: row[2].to_s,
                language: row[3].to_s,
                extlang: row[4].to_s,
                script: row[5].to_s,
                region: row[6].to_s,
                variant: row[7].to_s,
                extension: row[8].to_s,
                privateuse: row[9].to_s,
                name: row[10].to_s,
                lastmodified: row[11].to_i,
              }

              # Import every 100000 records
              if names_records.size >= 100000
                Gazetteer::Wof::Name.import(names_records, validate: false)
                names_records.clear
              end
              
              # Increment the progress bar
              progress_bar.increment
            rescue StandardError => e
              puts "Error processing line: #{e.message}"
            end
          end
        end

        # Import any remaining records
        Gazetteer::Wof::Name.import(names_records, validate: false) unless names_records.empty?

        puts "Imported names records from #{file_path} into PostgreSQL"
      end

      desc "Import SPR CSV file into PostgreSQL"
      task import_spr: :environment do
        file_path = Rails.root.join('db', 'gazetteer', 'wof', 'csv', 'gazetteer_wof_spr.csv')

        # Check if the file exists
        unless File.exist?(file_path)
          puts "File not found. Downloading..."
          Rake::Task['geoportal:gazetteer:wof:download'].invoke
        end

        # SPR Records Array
        spr_records = []

        # Count the total number of lines in the file
        total_lines = `wc -l "#{file_path}"`.strip.split(' ')[0].to_i

        # Initialize the progress bar
        progress_bar = ProgressBar.create(total: total_lines, format: "%a %b\u{15E7}%i %p%% %t")

        # Open the file
        File.open(file_path, 'r') do |f|
          until f.eof?
            begin
              text = f.readline
              row = CSV.parse_line(text, headers: false)

              # SPR Table Schema
              # t.bigint :wok_id
              # t.integer :parent_id
              # t.string :name
              # t.string :placetype
              # t.string :country
              # t.string :repo
              # t.decimal :latitude
              # t.decimal :longitude
              # t.decimal :min_latitude
              # t.decimal :min_longitude
              # t.decimal :max_latitude
              # t.decimal :max_longitude
              # t.integer :is_current
              # t.integer :is_deprecated
              # t.integer :is_ceased
              # t.integer :is_superseded
              # t.integer :is_superseding
              # t.integer :superseded_by
              # t.integer :supersedes
              # t.integer :lastmodified
              spr_records << {
                wok_id: row[0].to_i,
                parent_id: row[1].to_i,
                name: row[2].to_s,
                placetype: row[3].to_s,
                country: row[4].to_s,
                repo: row[5].to_s,
                latitude: row[6].to_d,
                longitude: row[7].to_d,
                min_latitude: row[8].to_d,
                min_longitude: row[9].to_d,
                max_latitude: row[10].to_d,
                max_longitude: row[11].to_d,
                is_current: row[12].to_i,
                is_deprecated: row[13].to_i,
                is_ceased: row[14].to_i,
                is_superseded: row[15].to_i,
                is_superseding: row[16].to_i,
                superseded_by: row[17].to_i,
                supersedes: row[18].to_i,
                lastmodified: row[19].to_i,
              }

              # Import every 100000 records
              if spr_records.size >= 100000
                Gazetteer::Wof::Spr.import(spr_records, validate: false)
                spr_records.clear
              end
              
              # Increment the progress bar
              progress_bar.increment
            rescue StandardError => e
              puts "Error processing line: #{e.message}"
            end
          end
        end

        # Import any remaining records
        Gazetteer::Wof::Spr.import(spr_records, validate: false) unless spr_records.empty?

        puts "Imported SPR records from #{file_path} into PostgreSQL"
      end
    end
  end
end
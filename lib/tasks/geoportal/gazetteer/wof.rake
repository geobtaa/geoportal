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
        Rake::Task['geoportal:gazetteer:wof:import_all'].invoke
        puts "CSV export and import completed successfully."
      end

      desc "Import CSV files into PostgreSQL"
      task import_all: :environment do
        import_tasks = {
          ancestors: {
            file: 'gazetteer_wof_ancestors.csv',
            schema: [
              { name: :wok_id, type: :bigint },
              { name: :ancestor_id, type: :integer },
              { name: :ancestor_placetype, type: :string },
              { name: :lastmodified, type: :integer }
            ],
            model: Gazetteer::Wof::Ancestor
          },
          concordances: {
            file: 'gazetteer_wof_concordances.csv',
            schema: [
              { name: :wok_id, type: :bigint },
              { name: :other_id, type: :string },
              { name: :other_source, type: :string },
              { name: :lastmodified, type: :integer }
            ],
            model: Gazetteer::Wof::Concordance
          },
          geojson: {
            file: 'gazetteer_wof_geojson.csv',
            schema: [
              { name: :wok_id, type: :bigint },
              { name: :body, type: :text },
              { name: :source, type: :string },
              { name: :alt_label, type: :string },
              { name: :is_alt, type: :boolean },
              { name: :lastmodified, type: :integer }
            ],
            model: Gazetteer::Wof::Geojson
          },
          names: {
            file: 'gazetteer_wof_names.csv',
            schema: [
              { name: :wok_id, type: :bigint },
              { name: :placetype, type: :string },
              { name: :country, type: :string },
              { name: :language, type: :string },
              { name: :extlang, type: :string },
              { name: :script, type: :string },
              { name: :region, type: :string },
              { name: :variant, type: :string },
              { name: :extension, type: :string },
              { name: :privateuse, type: :string },
              { name: :name, type: :string },
              { name: :lastmodified, type: :integer }
            ],
            model: Gazetteer::Wof::Name
          },
          spr: {
            file: 'gazetteer_wof_spr.csv',
            schema: [
              { name: :wok_id, type: :bigint },
              { name: :parent_id, type: :integer },
              { name: :name, type: :string },
              { name: :placetype, type: :string },
              { name: :country, type: :string },
              { name: :repo, type: :string },
              { name: :latitude, type: :decimal },
              { name: :longitude, type: :decimal },
              { name: :min_latitude, type: :decimal },
              { name: :min_longitude, type: :decimal },
              { name: :max_latitude, type: :decimal },
              { name: :max_longitude, type: :decimal },
              { name: :is_current, type: :integer },
              { name: :is_deprecated, type: :integer },
              { name: :is_ceased, type: :integer },
              { name: :is_superseded, type: :integer },
              { name: :is_superseding, type: :integer },
              { name: :superseded_by, type: :integer },
              { name: :supersedes, type: :integer },
              { name: :lastmodified, type: :integer }
            ],
            model: Gazetteer::Wof::Spr
          }
        }

        import_tasks.each do |task_name, details|
          import_csv_to_postgresql(details[:file], details[:schema], details[:model])
        end
      end

      def import_csv_to_postgresql(file_name, schema, model)
        file_path = Rails.root.join('db', 'gazetteer', 'wof', 'csv', file_name)

        unless File.exist?(file_path)
          puts "File not found. Downloading..."
          Rake::Task['geoportal:gazetteer:wof:download'].invoke
        end

        records = []
        total_lines = `wc -l "#{file_path}"`.strip.split(' ')[0].to_i
        progress_bar = ProgressBar.create(total: total_lines, format: "%a %b\u{15E7}%i %p%% %t")

        File.open(file_path, 'r') do |f|
          until f.eof?
            begin
              text = f.readline
              row = CSV.parse_line(text, headers: false)
              record = schema.each_with_index.map do |field, index|
                value = row[index]
                # Check if the value is a string ending with ".0" and convert to integer
                if value.is_a?(String) && value.end_with?('.0')
                  value = value.to_f.to_i
                end
                value = value.to_i if field[:type] == :integer || field[:type] == :bigint
                value = value.to_d if field[:type] == :decimal
                value = value == 'true' if field[:type] == :boolean
                [field[:name], value]
              end.to_h

              records << record

              if records.size >= 100000
                model.import(records, validate: false)
                records.clear
              end

              progress_bar.increment
            rescue StandardError => e
              puts "Error processing line: #{e.message}"
            end
          end
        end

        model.import(records, validate: false) unless records.empty?
        puts "Imported records from #{file_path} into PostgreSQL"
      end
    end
  end
end
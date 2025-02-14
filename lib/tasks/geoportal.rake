# frozen_string_literal: true
namespace :geoportal do
  task :ci do
    if Rails.env.test?    
      success = true
      Rake::Task['geoportal:index:seed'].invoke
      system('RAILS_ENV=test bundle exec rails test:system test') || success = false
      exit!(1) unless success
    end
  end

  desc 'Run Solr and GeoBlacklight for interactive development'
  task :server, [:rails_server_args] do
    require 'solr_wrapper'

    shared_solr_opts = { managed: true, verbose: true, persist: false, download_dir: 'tmp' }
    shared_solr_opts[:version] = ENV['SOLR_VERSION'] if ENV['SOLR_VERSION']

    SolrWrapper.wrap(shared_solr_opts.merge(port: 8983, instance_dir: 'tmp/blacklight-core')) do |solr|
      solr.with_collection(name: "blacklight-core", dir: Rails.root.join("solr", "conf").to_s) do
        puts "Solr running at http://localhost:8983/solr/blacklight-core/, ^C to exit"
        puts ' '
        begin
          Rake::Task['geoportal:index:seed'].invoke
          system "bundle exec rails s --binding=#{ENV.fetch('GEOPORTAL_SERVER_BIND_INTERFACE', '127.0.0.1')} --port=#{ENV.fetch('GEOPORTAL_SERVER_PORT', '3000')}"
          sleep
        rescue Interrupt
          puts "\nShutting down..."
        end
      end
    end
  end

  desc "Start solr server for testing."
  task :test do
    if Rails.env.test?
      shared_solr_opts = { managed: true, verbose: true, persist: false, download_dir: 'tmp' }
      shared_solr_opts[:version] = ENV['SOLR_VERSION'] if ENV['SOLR_VERSION']

      SolrWrapper.wrap(shared_solr_opts.merge(port: 8985, instance_dir: 'tmp/geoportal-core-test')) do |solr|
        solr.with_collection(name: "geoportal-core-test", dir: Rails.root.join("solr", "conf").to_s) do
          puts "Solr running at http://localhost:8985/solr/#/geoportal-core-test/, ^C to exit"
          begin
            Rake::Task['geoportal:index:seed'].invoke
            sleep
          rescue Interrupt
            puts "\nShutting down..."
          end
        end
      end
    else
      system('rake geoportal:test RAILS_ENV=test')
    end
  end

  desc "Start solr server for development."
  task :development do
    shared_solr_opts = { managed: true, verbose: true, persist: false, download_dir: 'tmp' }
    shared_solr_opts[:version] = ENV['SOLR_VERSION'] if ENV['SOLR_VERSION']

    SolrWrapper.wrap(shared_solr_opts.merge(port: 8983, instance_dir: 'tmp/geoportal-core-development')) do |solr|
      solr.with_collection(name: "geoportal-core-development", dir: Rails.root.join("solr", "conf").to_s) do
        puts "Solr running at http://localhost:8983/solr/#/geoportal-core-development/, ^C to exit"
        begin
          Rake::Task['geoblacklight:solr:seed'].invoke
          sleep
        rescue Interrupt
          puts "\nShutting down..."
        end
      end
    end
  end

  namespace :index do
    desc 'Put all sample data into solr'
    task :seed => :environment do
      docs = Dir['test/fixtures/files/**/*.json'].map { |f| JSON.parse File.read(f) }.flatten
      Blacklight.default_index.connection.add docs
      Blacklight.default_index.connection.commit
    end

    desc 'Put btaa sample data into solr'
    task :btaa => :environment do
      docs = Dir['test/fixtures/files/btaa_documents/*.json'].map { |f| JSON.parse File.read(f) }.flatten
      Blacklight.default_index.connection.add docs
      Blacklight.default_index.connection.commit
    end

    desc 'Delete all sample data from solr'
    task :delete_all => :environment do
      Blacklight.default_index.connection.delete_by_query '*:*'
      Blacklight.default_index.connection.commit
    end
  end

  # @CUSTOMIZATION
  # Require geomg_id_s as sort parameter
  namespace :allmaps do
    desc "Sidecars - Harvest: Crawl SolrDocuments to store Allmaps data locally"
    task harvest: [:environment] do
      cursor_mark = "*"
      loop do
        response = Blacklight.default_index.connection.get(
          "select", params: {
            q: "*:*", # all docs
            fl: "geomg_id_s, id",  # just id field
            cursorMark: cursor_mark, # use the cursor mark to handle paging
            rows: 1000,
            sort: "geomg_id_s asc" # must sort by id to use the cursor mark
          }
        )

        response["response"]["docs"].each do |doc|
          puts "Harvesting Allmaps data for #{doc["id"]}"
          Blacklight::Allmaps::StoreSidecarAnnotation.perform_later(doc["id"])
        end

        break if response["nextCursorMark"] == cursor_mark # this means the result set is finished
        cursor_mark = response["nextCursorMark"]
      end
    end

    desc "Index - add Allmaps facet data to GeoBlacklight solr"
    task georeferenced_facet: [:environment] do
      # Steps
      # 1. Use cursor to paginate all documents in Solr
      # 2. Determine which documents have georeferenced data
      # 3. Clean JSON for re-indexing
      # 4. Add georeferenced values
      # 5. Re-index the georeferenced documents

      # 1. Get all the documents from Solr
      cursor_mark = "*"
      loop do
        response = Blacklight.default_index.connection.get(
          "select", params: {
            q: "*:*", # all docs
            fl: "*",  # all fields
            cursorMark: cursor_mark, # use the cursor mark to handle paging
            rows: 1000,
            sort: "#{CatalogController.blacklight_config.default_solr_unique_key} asc" # must sort by id to use the cursor mark
          }
        )

        response["response"]["docs"].each do |doc|
          # 2. Determine which documents have georeferenced data
          solr_document = SolrDocument.find(doc[CatalogController.blacklight_config.default_solr_unique_key])
          
          if solr_document.allmaps_georeferenced?
            # 3. Clean JSON for re-indexing
            keys_for_deletion = %w[
              _version_
              timestamp
              solr_bboxtype
              solr_bboxtype__minX
              solr_bboxtype__minY
              solr_bboxtype__maxX
              solr_bboxtype__maxY
            ]

            cleaned_doc = doc.except!(*keys_for_deletion)

            # 4. Add georeferenced value
            cleaned_doc["b1g_georeferenced_allmaps_b"] = true

            # 5. Re-index the georeferenced documents
            Blacklight.default_index.connection.add cleaned_doc

          elsif solr_document.allmaps_georeferenceable?
            # 3. Clean JSON for re-indexing
            keys_for_deletion = %w[
              _version_
              timestamp
              solr_bboxtype
              solr_bboxtype__minX
              solr_bboxtype__minY
              solr_bboxtype__maxX
              solr_bboxtype__maxY
            ]

            cleaned_doc = doc.except!(*keys_for_deletion)

            # 4. Add georeferenced value
            cleaned_doc["b1g_georeferenced_allmaps_b"] = false

            # 5. Re-index the georeferenced documents
            Blacklight.default_index.connection.add cleaned_doc
          end
        end

        break if response["nextCursorMark"] == cursor_mark # this means the result set is finished
        cursor_mark = response["nextCursorMark"]
      end
      Blacklight.default_index.connection.commit
    end
  end
end

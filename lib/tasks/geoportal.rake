# frozen_string_literal: true

desc 'Run test suite'
task :ci do
  shared_solr_opts = { managed: true, verbose: true, persist: false, download_dir: 'tmp' }
  shared_solr_opts[:version] = ENV['SOLR_VERSION'] if ENV['SOLR_VERSION']

  success = true
  SolrWrapper.wrap(shared_solr_opts.merge(port: 8985, instance_dir: 'tmp/geoportal-core-test')) do |solr|
    solr.with_collection(name: "geoportal-core-test", dir: Rails.root.join("solr", "conf").to_s) do
      system('RAILS_ENV=test bundle exec rake geoblacklight:index:seed')
      system('RAILS_ENV=test bundle exec rails test:system test') || success = false
    end
  end

  exit!(1) unless success
end

namespace :geoportal do
  desc 'Run Solr and GeoBlacklight for interactive development'
  task :server, [:rails_server_args] do
    require 'solr_wrapper'

    shared_solr_opts = { managed: true, verbose: true, persist: false, download_dir: 'tmp' }
    shared_solr_opts[:version] = ENV['SOLR_VERSION'] if ENV['SOLR_VERSION']

    SolrWrapper.wrap(shared_solr_opts.merge(port: 8983, instance_dir: 'tmp/geoportal-core-development')) do |solr|
      solr.with_collection(name: "geoportal-core-development", dir: Rails.root.join("solr", "conf").to_s) do
        puts "Solr running at http://localhost:8983/solr/geoportal-core-development/, ^C to exit"
        puts ' '
        begin
          Rake::Task['geoblacklight:solr:seed'].invoke
          system "bundle exec rails s --binding=#{ENV.fetch('GEOPORTAL_SERVER_BIND_INTERFACE', '0.0.0.0')} --port=#{ENV.fetch('GEOPORTAL_SERVER_PORT', '3000')}"
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
            Rake::Task['geoblacklight:solr:seed'].invoke
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
end

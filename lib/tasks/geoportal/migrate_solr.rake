# frozen_string_literal: true

require 'rsolr'
require 'ostruct'
require 'yaml'

# MY_ENV = ENV['ENV'] || 'development'
# CONFIG = OpenStruct.new(YAML.load_file("config/blacklight.yml")[MY_ENV])

namespace :geoportal do
  desc 'Migrate from old Solr to new Solr'
  task migrate_solr: :environment do

    # Connect to OLD SOLR
    old_solr = RSolr.connect :url => "http://localhost:8984/solr/blacklightcore"

    # Connect to NEW SOLR
    new_solr = RSolr.connect :url => CONFIG.url

    # Search request
    response = old_solr.get 'select', params: { q: '*:*', rows: '10000' }

    response["response"]["docs"].each do |doc|
      puts doc['uuid'].to_s

      # Remove "score" from hash before re-indexing
      doc.delete("score")

      # Remove "version"
      doc.delete("_version_")

      # Add Doc to New Solr
      new_solr.add(doc)

      # Committing each doc
      # This is silly, but also helps to check for bbox/centroid errors
      new_solr.commit(softCommit: true)
    rescue Exception => e
      puts "Caught #{e}"
      puts "ERROR - #{doc['uuid']}"
    end
  end
end

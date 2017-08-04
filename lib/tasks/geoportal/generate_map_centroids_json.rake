require 'rsolr'

namespace :geoportal do
  desc 'Test URIs stored in Solr index'
  task generate_map_centroids_json: :environment do
    # Connect to solr
    solr = RSolr.connect :url => 'http://localhost:8983/solr/geoportal'

    # Search request
    response = solr.get 'select', :params => {:q => '*:*', :rows => '10000'}

    docs = []
    response["response"]["docs"].each_with_index do |doc, index|
      begin
        if !doc['centroid_sdv'].empty?
          entry = {}
          entry['uuid_sdv'] = doc['uuid_sdv']
          entry['dc_title_sdv'] = doc['dc_title_sdv']
          entry['centroid_sdv'] = doc['centroid_sdv']

          docs << entry
        end
      rescue
        puts "BBox or centroid no good - #{doc['uuid']}"
      end
    end

    centroids_file = "#{Rails.root}/public/centroids.json"
    File.open(centroids_file, "w"){|f| f.write(JSON.generate(docs))}
  end
end

require 'rsolr'

namespace :geoportal do
  desc 'Test URIs stored in Solr index'
  task generate_centroids_json: :environment do
    # Connect to solr
    solr = RSolr.connect :url => CONFIG.url

    # Search request
    response = solr.get 'select', :params => {:q => '*:*', :rows => '100000'}

    docs = []
    response["response"]["docs"].each_with_index do |doc, index|
      begin
        if !doc['centroid_s'].empty?
          entry = {}
          entry['uuid'] = doc['uuid']
          entry['dc_title_s'] = doc['dc_title_s']
          entry['b1g_centroid_ss'] = doc['centroid_s']

          docs << entry
        end
      rescue Exception => e
        puts "Caught #{e}"
        puts "BBox or centroid no good - #{doc['uuid']}"
      end
    end

    centroids_file = "#{Rails.root}/public/centroids.json"
    File.open(centroids_file, "w"){|f| f.write(JSON.generate(docs))}
  end
end

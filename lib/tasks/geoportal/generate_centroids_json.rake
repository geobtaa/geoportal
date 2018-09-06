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
        if !doc['b1g_centroid_ss'].empty?
          entry = {}
          entry['layer_slug_s'] = doc['layer_slug_s']
          entry['dc_title_s'] = doc['dc_title_s']
          entry['b1g_centroid_ss'] = doc['b1g_centroid_ss']

          docs << entry
        end
      rescue Exception => e
        puts "Caught #{e}"
        puts "BBox or centroid no good - #{doc['layer_slug_s']}"
      end
    end

    centroids_file = "#{Rails.root}/public/centroids.json"
    File.open(centroids_file, "w"){|f| f.write(JSON.generate(docs))}
  end
end

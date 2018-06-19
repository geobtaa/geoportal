require 'rsolr'
require 'ostruct'
require 'yaml'

MY_ENV = ENV['ENV'] || 'development'
CONFIG = OpenStruct.new(YAML.load_file("config/blacklight.yml")[MY_ENV])

namespace :geoportal do
  desc 'Generate centroids from solr_geom values'
  task generate_centroids_solr: :environment do

    # Connect to solr
    solr = RSolr.connect :url => CONFIG.url

    # Search request
    response = solr.get 'select', :params => {:q => '*:*', :rows => '15000'}

    response["response"]["docs"].each_with_index do |doc, index|
      begin
        puts "#{doc['layer_slug_s']} / #{doc['solr_geom'].to_s}"

        geom_field = doc['solr_geom'].to_s

        exp = /^\s*ENVELOPE\(
                    \s*([-\.\d]+)\s*,
                    \s*([-\.\d]+)\s*,
                    \s*([-\.\d]+)\s*,
                    \s*([-\.\d]+)\s*
                    \)\s*$/x # uses 'x' option for free-spacing mode
        bbox_match = exp.match(geom_field)
        return geom_field unless bbox_match # return as-is, not a WKT
        w, e, n, s = bbox_match.captures

        # West and East
        # Calculate average
        lng = [w.to_f,e.to_f]
        lng = lng.inject{|sum,el| sum + el}.to_f / lng.size

        # North and South
        # Calculate average
        lat = [s.to_f,n.to_f]
        lat = lat.inject{|sum,el| sum + el}.to_f / lat.size

        # Centroid in Solr is lat,lng
        centroid = [lat,lng]
        centroid = centroid.join(",")

        # String Field
        doc['centroid_s'] = centroid

        # Remove "score" from hash before re-indexing
        doc.delete("score")

        #Add Doc
        solr.add(doc)

        #Committing each doc
        # This is silly, but also helps to check for bbox/centroid errors
        solr.commit({softCommit: true})
      rescue
        puts "BBox or centroid no good - #{doc['layer_slug_s']}"
      end
    end
  end
end

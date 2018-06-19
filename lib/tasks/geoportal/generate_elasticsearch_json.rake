require 'rsolr'

# Afterward, to import json dump to ElasticSearch:
# cat solr_docs.json | jq -c '.[] | {"index": {"_index": "geoportal", "_type":"node", "_id": .layer_slug_s}}, .' | curl -XPOST localhost:9200/_bulk --data-binary @-
namespace :geoportal do
  desc 'Make a Solr document json dump to import into ES'
  task generate_elasticsearch_json: :environment do
    # Connect to solr
    solr = RSolr.connect :url => CONFIG.url

    # Search request
    response = solr.get 'select', :params => {:q => '*:*', :rows => '10000'}

    docs = []
    response["response"]["docs"].each_with_index do |doc, index|

      # Remove "score" from hash
      doc.delete("score")

      # Add to docs array
      docs << doc
    end

    docs_file = "#{Rails.root}/public/solr_docs.json"
    File.open(docs_file, "w"){|f| f.write(JSON.generate(docs))}
  end
end

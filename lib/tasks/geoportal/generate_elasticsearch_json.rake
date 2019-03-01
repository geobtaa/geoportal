# frozen_string_literal: true

require 'rsolr'

# Afterward, to import json dump to ElasticSearch:
# cat solr_docs.json |
# jq -c '.[] |
# {"index": {"_index": "geoportal", "_type":"node", "_id": .uuid}}, .' |
# curl -XPOST localhost:9200/_bulk --data-binary @-
namespace :geoportal do
  desc 'Make a Solr document json dump to import into ES'
  task generate_elasticsearch_json: :environment do
    # Search request
    response = Blacklight.default_index.connection.get 'select', params: { q: '*:*', rows: '10000' }

    docs = []
    response["response"]["docs"].each do |doc|
      # Remove "score" from hash
      doc.delete("score")
      # Add to docs array
      docs << doc
    end

    docs_file = "#{Rails.public_path}/solr_docs.json"
    File.open(docs_file, "w") { |f| f.write(JSON.generate(docs)) }
  end
end

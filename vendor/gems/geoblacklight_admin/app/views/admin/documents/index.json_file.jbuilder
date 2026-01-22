json.ignore_nil!

json.array! @documents.load_all.map do |document|
  next if document.nil? # Guard against Solr/DB being out of sync

  json.partial! "json_btaa_aardvark", document: document
end

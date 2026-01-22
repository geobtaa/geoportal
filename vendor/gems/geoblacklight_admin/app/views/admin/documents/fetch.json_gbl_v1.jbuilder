json.ignore_nil!

json.array! @documents.map do |document|
  next if document.nil? # Guard against Solr/DB being out of sync

  json.partial! "json_gbl_v1", document: document
end

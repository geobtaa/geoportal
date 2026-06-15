# Connect to Solr
solr = RSolr.connect(url: "http://localhost:8983/solr/blacklight-core")

# Get Document JSON
json_output = Admin::DocumentsController.render("_json_btaa_aardvark",
            locals: {document: d})

response = solr.update(data: json_output, headers: {"Content-Type" => "application/json"})

puts response.inspect

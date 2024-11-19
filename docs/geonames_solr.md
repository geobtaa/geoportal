# Solr Geonames Setup

## Install Steps

### Navigate to the Solr Wrapper installation directory
`cd tmp/solr `

### Create the collection
`bin/solr create -c geonames`

### Add the field types
```
curl -X POST -H 'Content-type:application/json'  http://localhost:8983/solr/geonames/schema -d '{
  "add-field-type":{      
    "name":"tag",                                      
    "class":"solr.TextField",           
    "postingsFormat":"FST50",      
    "omitNorms":true,
    "omitTermFreqAndPositions":true,
    "indexAnalyzer":{
      "tokenizer":{
         "class":"solr.StandardTokenizerFactory" },
      "filters":[
        {"class":"solr.EnglishPossessiveFilterFactory"},
        {"class":"solr.ASCIIFoldingFilterFactory"},
        {"class":"solr.LowerCaseFilterFactory"},
        {"class":"solr.ConcatenateGraphFilterFactory", "preservePositionIncrements":false }
      ]},
    "queryAnalyzer":{
      "tokenizer":{
         "class":"solr.StandardTokenizerFactory" },
      "filters":[
        {"class":"solr.EnglishPossessiveFilterFactory"},
        {"class":"solr.ASCIIFoldingFilterFactory"},
        {"class":"solr.LowerCaseFilterFactory"}
      ]}
    },

  "add-field":{"name":"name", "type":"text_general"},

  "add-field":{"name":"name_tag", "type":"tag", "stored":false },

  "add-copy-field":{"source":"name", "dest":["name_tag"]}
}'
```

### Add the request handler

```
curl -X POST -H 'Content-type:application/json' http://localhost:8983/solr/geonames/config -d '{
  "add-requesthandler" : {
    "name": "/tag",                                    
    "class":"solr.TaggerRequestHandler",
    "defaults":{"field":"name_tag"}
  }
}'
```

### Tagger example for Minneapolis

```
curl -X POST \
  'http://localhost:8983/solr/geonames/tag?overlaps=NO_SUB&tagsLimit=5000&fl=geonameid_i,name,countrycode&wt=json&indent=on' \                            
  -H 'Content-Type:text/plain' -d 'Minneapolis'
```

### Lat/Long search example for Minneapolis

```
curl -v -X POST \
  'http://localhost:8983/solr/geonames/select?q=*:*&fq=%7B!bbox%20sfield=location_p%7D&pt=44.9135128,-93.2802394&d=1'
```

### Lat/Long search example for Minneapolis sorted by distance descending

```
curl -v -X POST \
  'http://localhost:8983/solr/geonames/select?q=*:*&fq=%7B!bbox%20sfield=location_p%7D&pt=44.9135128,-93.2802394&d=1&sort=geodist(location_p,44.9135128,-93.2802394)%20desc'
```

### Lat/Long search example for Minneapolis sorted by distance ascending and including distance

```
curl -v -X POST \
  'http://localhost:8983/solr/geonames/select?q=*:*&fq=%7B!bbox%20sfield=location_p%7D&pt=44.9135128,-93.2802394&d=1&sort=geodist(location_p,44.9135128,-93.2802394)%20asc&fl=*,score,geodist:geodist(location_p,44.9135128,-93.2802394)'
```

### Tagger example for Minneapolis

```
curl -v -X POST \
  'http://localhost:8983/solr/geonames/tag?overlaps=NO_SUB&tagsLimit=5000&fl=geonameid_i,name,countrycode&wt=json&indent=on' -H 'Content-Type:text/plain' -d 'Minneapolis'
```

### Lat/Long search example for Minneapolis sorted by distance ascending and including distance

```
curl -v -X POST \
  'http://localhost:8983/solr/geonames/select?q=*:*&fq=%7B!bbox%20sfield=location_p%7D&pt=44.9135128,-93.2802394&d=1&sort=geodist(location_p,44.9135128,-93.2802394)%20asc&fl=*,score,geodist:geodist(location_p,44.9135128,-93.2802394)'
```

### Combine tagger and geospatial search to sort the tagged geonames for "Minneapolis"

```ruby
require 'net/http'
require 'json'
require 'uri'

# Step 1: Tag the text to get geoname IDs
uri = URI('http://localhost:8983/solr/geonames/tag?overlaps=NO_SUB&tagsLimit=5000&fl=geonameid_i&wt=json')
request = Net::HTTP::Post.new(uri)
request['Content-Type'] = 'text/plain'
request.body = 'Minneapolis'

response = Net::HTTP.start(uri.hostname, uri.port) do |http|
  http.request(request)
end

# Parse the JSON response to extract geoname IDs
tagged_response = JSON.parse(response.body)
geoname_ids = tagged_response['response']['docs'].map { |doc| doc['geonameid_i'] }.join(' OR ')

# Step 2: Use the geoname IDs to perform a geospatial query with sorting
uri = URI("http://localhost:8983/solr/geonames/select?q=geonameid_i:(#{geoname_ids})&fq=%7B!bbox%20sfield=location_p%7D&pt=44.9135128,-93.2802394&d=1&sort=geodist(location_p,44.9135128,-93.2802394)%20asc&fl=*,score,geodist:geodist(location_p,44.9135128,-93.2802394)")

# Troubleshooting
uri = URI("http://localhost:8983/solr/geonames/select?q=geonameid_i:(#{geoname_ids})&sort=geodist(location_p,44.9135128,-93.2802394)%20asc&fl=*,score,geodist:geodist(location_p,44.9135128,-93.2802394)&wt=json")

request = Net::HTTP::Post.new(uri)

response = Net::HTTP.start(uri.hostname, uri.port) do |http|
  http.request(request)
end

# Output the response
puts response.body
```
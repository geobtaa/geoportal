# Solr Geonames Setup

## Install Steps

Follow the Solr documentation:
https://solr.apache.org/guide/solr/latest/query-guide/tagger-handler.html#tutorial-with-geonames

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
  'http://localhost:8983/solr/geonames/tag?overlaps=NO_SUB&tagsLimit=5000&fl=geonameid_i,name,countrycode&wt=json&indent=on' -H 'Content-Type:text/plain' -d 'Minneapolis'
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
require 'rsolr'
require 'json'

# Initialize the RSolr client
solr = RSolr.connect url: 'http://localhost:8983/solr/geonames'

# Step 1: Tag the text to get geoname IDs
response = solr.post 'tag', params: {
  overlaps: 'NO_SUB',
  tagsLimit: 5000,
  fl: 'geonameid_i',
  wt: 'json'
}, data: 'Minneapolis', headers: { 'Content-Type' => 'text/plain' }

# Parse the JSON response to extract geoname IDs
geoname_ids = response['response']['docs'].map { |doc| doc['geonameid_i'] }

# Fetch Geoname objects from the database using the extracted IDs, preserving order
geonames = Geoname.where(geonameid: geoname_ids).order(Arel.sql("array_position(array[#{geoname_ids.join(',')}], geonameid)"))

# Step 2: Use the geoname IDs to perform a geospatial query with sorting
response = solr.get 'select', params: {
  q: "geonameid_i:(#{geoname_ids})",
  fq: '{!bbox sfield=location_p}',
  pt: '44.9135128,-93.2802394',
  d: 1000,
  sort: 'geodist(location_p,44.9135128,-93.2802394)%20asc',
  fl: '*,score,geodist:geodist(location_p,44.9135128,-93.2802394)',
  wt: 'json'
}

# Output the response
puts response['response']
```

### Ruby Class example

```ruby
require 'rsolr'
require 'json'

class GeonamesTagger
  def initialize(solr_url)
    @solr = RSolr.connect url: solr_url
  end

  # Method to tag the text and return geoname IDs
  def tag_text(text)
    response = @solr.post 'tag', params: {
      overlaps: 'NO_SUB',
      tagsLimit: 50,
      fl: 'geonameid_i',
      wt: 'json'
    }, data: text, headers: { 'Content-Type' => 'text/plain' }

    # Parse the response to extract geoname IDs
    geoname_ids = response['response']['docs'].map { |doc| doc['geonameid_i'] }

    # Fetch Geoname objects from the database using the extracted IDs, preserving order
    geonames = Geoname.where(geonameid: geoname_ids).order(Arel.sql("array_position(array[#{geoname_ids.join(',')}], geonameid)"))
  end

  # Method to perform a geospatial search using geoname IDs
  def search_by_geoname_ids(geoname_ids, latitude, longitude, distance)
    query = geoname_ids.join(' OR ')
    response = @solr.get 'select', params: {
      q: "geonameid_i:(#{query})",
      fq: '{!bbox sfield=location_p}',
      pt: "#{latitude},#{longitude}",
      d: distance,
      sort: "geodist(location_p,#{latitude},#{longitude}) asc",
      fl: "*,score,geodist:geodist(location_p,#{latitude},#{longitude})",
      wt: 'json'
    }

    # Parse the response to extract geoname IDs
    geoname_ids = response['response']['docs'].map { |doc| doc['geonameid_i'] }

    # Fetch Geoname objects from the database using the extracted IDs, preserving order
    geonames = Geoname.where(geonameid: geoname_ids).order(Arel.sql("array_position(array[#{geoname_ids.join(',')}], geonameid)"))
  end
end

# Example usage:
# Initialize the GeonamesTagger
geonames_tagger = Gazetteer::Geonames::Tagger.new('http://localhost:8983/solr/geonames')

# Tag the text to get geoname IDs
geonames = geonames_tagger.tag_text('Minneapolis')

# Perform a geospatial search using the geoname IDs
geonames_tagger.search_by_geoname_ids(geonames.map(&:geonameid), 44.9135128, -93.2802394, 1000)
```

### Examples

```ruby
# Examples:
text = "Washington Monument"
latitude = 38.8936445
longitude = -77.0141402
distance = 1000

geonames_tagger = GeonamesTagger.new('http://localhost:8983/solr/geonames')
geonames = geonames_tagger.tag_text(text)
geonames_tagger.search_by_geoname_ids(geonames.map(&:geonameid), latitude, longitude, distance)

# BTAA Geoportal / Minnesota Bear Harvest (Title and Description)
# https://geo.btaa.org/catalog/7298a44d-5d28-49ea-8af7-3b06695935ac
text = "Minnesota Bear Harvest [Minnesota] 
Annual Minnesota Bear harvest, summarized by bear permit areas.
To summarize and map bear harvest density.
1996 - 2014"
latitude = 45.0792108
longitude = -93.4993328
distance = 1000

geonames_tagger = GeonamesTagger.new('http://localhost:8983/solr/geonames')
geonames_tagger.tag_and_search(text, latitude, longitude, distance)

# BTAA Geoportal / Carver County, Minnesota (Title and Description)
# https://geo.btaa.org/catalog/p16022coll624:927
text = "Carver County, Minnesota
Description:
'Source: General highway map, Carver County, Minnesota (1976).'; '11-16-78. 5,R-37,090.'; Includes location map.
46 x 60 centimeters"
latitude = 44.776566
longitude = -93.764696
distance = 1000

geonames_tagger = GeonamesTagger.new('http://localhost:8983/solr/geonames')
geonames_tagger.tag_and_search(text, latitude, longitude, distance)

# BTAA Geoportal / 03S 12W - Survey Map of Texas Township in Kalamazoo County, Page 2 [Michigan]

text = "03S 12W - Survey Map of Texas Township in Kalamazoo County, Page 2 [Michigan]
This survey map of Texas Township in Kalamazoo County, Michigan describes an occupied island in a lake located in Section 16 of the township map. The map was drawn in 1856."
latitude = 42.236389
longitude = -85.587222
distance = 1000

geonames_tagger = GeonamesTagger.new('http://localhost:8983/solr/geonames')
geonames_tagger.tag_and_search(text, latitude, longitude, distance)
```

# TODO:

* Who's on First downloader and DB adapter for WOF sqlite3 database
https://whosonfirst.org/download/


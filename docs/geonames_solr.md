# navigate to the solr directory
ewlarson@beanburrito-5 geoportal % cd tmp/solr 

# create the collection
ewlarson@beanburrito-5 geoportal % bin/solr create -c geonames 

# add the field types
ewlarson@beanburrito-5 geoportal % curl -X POST -H 'Content-type:application/json'  http://localhost:8983/solr/geonames/schema -d '{
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

# add the request handler
ewlarson@beanburrito-5 solr % curl -X POST -H 'Content-type:application/json' http://localhost:8983/solr/geonames/config -d '{
  "add-requesthandler" : {
    "name": "/tag",                                    
    "class":"solr.TaggerRequestHandler",
    "defaults":{"field":"name_tag"}
  }
}'
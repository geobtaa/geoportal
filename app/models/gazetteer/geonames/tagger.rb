# The Gazetteer::Geonames::Tagger class is responsible for interacting with a Solr server
# to tag text with geoname IDs and perform geospatial searches using those IDs.
#
# == Initialization
# The class is initialized with a Solr URL, which is used to establish a connection to the Solr server.
#
# === Example
#   tagger = Gazetteer::Geonames::Tagger.new('http://localhost:8983/solr/geonames')
#   results = tagger.tag_text(text)
#   puts results
#
# == Methods
# - tag_text(text): Tags the provided text and returns an array of geoname IDs.
# - search_by_geoname_ids(geoname_ids, latitude, longitude, distance): Performs a geospatial search using the provided geoname IDs and returns matching geoname objects.
class Gazetteer::Geonames::Tagger

  # Initializes a new instance of the Tagger class.
  #
  # @param solr_url [String] The URL of the Solr server to connect to.
  def initialize(solr_url)
    @solr = RSolr.connect url: solr_url
  end

  # Tags the given text and returns an array of geoname IDs.
  #
  # @param text [String] The text to be tagged.
  # @return [Array<Integer>] An array of geoname IDs extracted from the text.
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
    geonames = Gazetteer::Geonames::Name.where(
      geoname_id: geoname_ids
    ).order(
      Arel.sql("array_position(array[#{geoname_ids.join(',')}], geoname_id)")
    )
  end

  # Performs a geospatial search using the provided geoname IDs.
  #
  # @param geoname_ids [Array<Integer>] An array of geoname IDs to search for.
  # @param latitude [Float] The latitude for the geospatial search.
  # @param longitude [Float] The longitude for the geospatial search.
  # @param distance [Float] The distance (in kilometers) for the geospatial search.
  # @return [Array<Geoname>] An array of Geoname objects that match the search criteria.
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
    # Top hit should be the most relevant to our document
    geonames = Gazetteer::Geonames::Name.where(
      geoname_id: geoname_ids
    ).order(
      Arel.sql("array_position(array[#{geoname_ids.join(',')}], geoname_id)")
    )
  end
end
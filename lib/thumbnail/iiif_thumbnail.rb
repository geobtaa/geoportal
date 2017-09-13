module IiifThumbnail
  ##
  # Formats and returns a thumbnail url from an International Image
  # Interoperability Framework endpoint.
  # @param [SolrDocument]
  # @param [Integer] thumbnail size
  # @return [String] iiif thumbnail url
  def self.thumbnail_url(document, size)
    "#{document.viewer_endpoint.gsub('info.json', '')}full/#{size},/0/default.jpg"
  end
end

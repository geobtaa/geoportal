module ThumbnailConcern
  extend Geoblacklight::SolrDocument

  ##
  # Returns a thumbnail url for the document.
  # @return [String]
  def thumbnail_url
    @thumbnail_url ||= Thumbnail.new(self).url
  end
end

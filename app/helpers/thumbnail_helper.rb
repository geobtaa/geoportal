module ThumbnailHelper
  ##
  # Returns the GeoBlacklight thumbnail linked to the item record
  # @param document [SolrDocument]
  # @param opts [Hash]
  # @option opts [Int] :counter the index of the item in the result set.
  # @return [String]
  def gbl_thumbnail_img(document, opts = { counter: nil })
    img_tag = gbl_thumbnail_img_tag(document)
    link_to img_tag, url_for_document(document), document_link_params(document, opts)
  end

  ##
  # Returns html for displaying a geoblacklight thumbnail. If there isn't a
  # thumbnail url, a placeholder showing the geometry type is displayed. If there
  # is a thumbnail url, a placeholder is displayed along with an image tag. The
  # thumbnail image is then loaded asynchronously via javascript.
  # @param [SolrDocument]
  # @return [String]
  def gbl_thumbnail_img_tag(document)
    url = document.thumbnail_url
    h = [geoblacklight_icon(document['layer_geom_type_s'])]
    h.unshift content_tag(:img, nil, class: 'item-thumbnail', data: { aload: url.to_s }) if url
    safe_join h
  end
end

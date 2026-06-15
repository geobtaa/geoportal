# frozen_string_literal: true

module GeoblacklightAdmin
  class ImageService
    module ImageMapLayer
      ##
      # Formats and returns a thumbnail url from an ESRI Image Map Layer endpoint.
      # information about the layer.
      # @param [SolrDocument]
      # @param [Integer] thumbnail size
      # @return [String] thumbnail url
      def self.image_url(document, _size)
        "#{document.viewer_endpoint}/info/thumbnail/thumbnail.png"
      end
    end
  end
end

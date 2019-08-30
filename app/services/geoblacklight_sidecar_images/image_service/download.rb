# frozen_string_literal: true

module GeoblacklightSidecarImages
  class ImageService
    module Download
      ##
      # Formats and returns an image url from a http(s) endpoint.
      # @param [SolrDocument]
      # @param [Integer] thumbnail size (unused)
      # @return [String] image url
      def self.image_url(document, _size)
        "#{document.viewer_endpoint}"
      end
    end
  end
end

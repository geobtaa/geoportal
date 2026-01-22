# frozen_string_literal: true

module GeoblacklightAdmin
  class ImageService
    module Iiif
      ##
      # Formats and returns a thumbnail url from an International Image
      # Interoperability Framework endpoint.
      # @param [SolrDocument]
      # @param [Integer] thumbnail size
      # @return [String] iiif thumbnail url
      def self.image_url(document, _size)
        "#{document.viewer_endpoint.gsub("info.json", "")}full/max/0/default.jpg"
      end
    end
  end
end

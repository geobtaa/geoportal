# frozen_string_literal: true

module GeoblacklightAdmin
  class ImageService
    module Wms
      ##
      # Formats and returns a thumbnail url from a Web Map Service endpoint.
      # This utilizes the GeoServer specific 'reflect' service to generate
      # parameters like bbox that are difficult to tweak without more detailed
      # information about the layer.
      # @param [SolrDocument]
      # @param [Integer] thumbnail size
      # @return [String] wms thumbnail url
      def self.image_url(document, size)
        endpoint = document.viewer_endpoint
        "#{endpoint}/reflect?" \
          "&FORMAT=image%2Fpng" \
          "&TRANSPARENT=TRUE" \
          "&LAYERS=#{document["gbl_wxsIdentifier_s"]}" \
          "&WIDTH=#{size}" \
          "&HEIGHT=#{size}"
      end
    end
  end
end

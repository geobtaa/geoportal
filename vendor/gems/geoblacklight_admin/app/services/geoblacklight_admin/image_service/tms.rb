# frozen_string_literal: true

require "addressable/uri"

module GeoblacklightAdmin
  class ImageService
    module Tms
      ##
      # Formats and returns a thumbnail url for a TMS endpoint from a Web Map Service.
      # This utilizes the GeoServer specific 'reflect' service to generate
      # parameters like bbox that are difficult to tweak without more detailed
      # information about the layer.
      # @param [SolrDocument]
      # @param [Integer] thumbnail size
      # @return [String] tms thumbnail url
      def self.image_url(document, size)
        # Begins with:
        # https://cugir.library.cornell.edu/geoserver/gwc/service/tms/1.0.0/cugir%3Acugir007957@EPSG%3A3857@png/{z}/{x}/{y}.png

        # Works with:
        # https://cugir.library.cornell.edu/geoserver/wms/reflect?&FORMAT=image%2Fpng&TRANSPARENT=TRUE&LAYERS=cugir007957&WIDTH=1500&HEIGHT=1500

        # Parse the URL using Addressable::URI which handles more complex URIs
        parsed_url = Addressable::URI.parse(document.viewer_endpoint)

        # Build a hash to store the extracted components
        parsed_data = {
          base_url: "#{parsed_url.scheme}://#{parsed_url.host}#{":" + parsed_url.port.to_s if parsed_url.port}",
          path_pattern: parsed_url.path
        }

        endpoint = parsed_data[:base_url]
        "#{endpoint}/geoserver/wms/reflect?" \
          "&FORMAT=image%2Fpng" \
          "&TRANSPARENT=TRUE" \
          "&LAYERS=#{document["gbl_wxsIdentifier_s"]}" \
          "&WIDTH=#{size}" \
          "&HEIGHT=#{size}"
      end
    end
  end
end

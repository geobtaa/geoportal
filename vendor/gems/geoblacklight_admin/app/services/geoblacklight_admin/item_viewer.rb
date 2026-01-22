# frozen_string_literal: true

module GeoblacklightAdmin
  class ItemViewer
    def initialize(distributions)
      @distributions = distributions
      @keys = distributions.keys.collect { |k| reference_uri_2_key(k) }
    end

    def viewer_protocol
      viewer_preference.find { |vp| @keys.include?(vp) } || :map
    end

    def viewer_endpoint
      @distributions[viewer_protocol_2_endpoint]
    end

    def reference_uri_2_key(value)
      Geoblacklight::Constants::URI.key(value)
    end

    def viewer_protocol_2_endpoint
      Geoblacklight::Constants::URI[viewer_protocol]
    end

    def viewer_preference
      [:cog, :pmtiles, :oembed, :index_map, :tilejson, :xyz, :wmts, :tms, :wms, :iiif_manifest, :iiif, :tiled_map_layer, :dynamic_map_layer,
        :image_map_layer, :feature_layer]
    end
  end
end

module Geoblacklight
  class ItemViewer
    def initialize(references)
      @references = references
    end

    def viewer_protocol
      return 'map' if viewer_preference.nil?
      viewer_preference.keys.first.to_s
    end

    def viewer_endpoint
      return '' if viewer_preference.nil?
      viewer_preference.values.first.to_s
    end

    # PENN STATE
    # Ex. /catalog/d943e4bf-efbc-479d-83f6-78dbac2a981f
    # CDM big image
    def cdm_big_image
      if @references.download.present?
        if @references.download.reference[1].include?("getdownloaditem")
          return @references.download
        end
      end
      return nil
    end

    def iu_fedora_big_image
      # Test institution - "Indiana"
      # Test dc_format_s - "JPEG" (mostly should be image-ish)
      # Render SCREEN datastream
      # http://fedora.dlib.indiana.edu:8080/fedora/objects/iudl%3A1074633/datastreams/SCREEN/content
      if @references.download.present?
        if @references.download.reference[1].include?("getdownloaditem")
          return @references.download
        end
      end
      return nil
    end

    def wms
      @references.wms
    end

    def iiif
      @references.iiif
    end

    def tiled_map_layer
      @references.tiled_map_layer
    end

    def dynamic_map_layer
      @references.dynamic_map_layer
    end

    def feature_layer
      @references.feature_layer
    end

    def image_map_layer
      @references.image_map_layer
    end

    def viewer_preference
      [cdm_big_image, wms, iiif, tiled_map_layer, dynamic_map_layer,
       image_map_layer, feature_layer].compact.map(&:to_hash).first
    end
  end
end

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

    # Download image
    def download
      if @references.download.present?
        # .jpg (Michigan State / 06e7f566-852a-4914-929d-1bef38132eba)
        # /screen/ (Indiana / 697a9115-cdb3-4108-8a1f-1136e98c24d6)
        # getdownloaditem (Penn State / d943e4bf-efbc-479d-83f6-78dbac2a981f)
        if ['.jpg', '/screen/', 'getdownloaditem'].any? { |str| @references.download.reference[1].include?(str) }
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
      [wms, iiif, download, tiled_map_layer, dynamic_map_layer,
       image_map_layer, feature_layer].compact.map(&:to_hash).first
    end
  end
end

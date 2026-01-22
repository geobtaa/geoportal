# frozen_string_literal: true

module GeoblacklightAdmin
  class ImageService
    module IiifManifest
      require "down"
      require "json"

      ## IIIF Manifests are messy
      # - some have a sequence
      # - some have items
      # - some have canvases
      # - some have images
      # - some have resources
      # - some have thumbnails

      ## BTAA Examples
      # Indiana - No IIIF Manifests (that I know of)
      #
      # Illinois - IIIF Manifests have thumbnail entries
      # ex. https://digital.library.illinois.edu/items/a07f9c70-994e-0134-2096-0050569601ca-8/manifest
      #
      # Iowa - No IIIF Manifests (that I know of)
      #
      # Maryland - No IIIF Manifests (that I know of)
      #
      # Michigan - IIIF Manifests have thumbnail entries
      # ex. https://quod.lib.umich.edu/cgi/i/image/api/search/clark1ic:003287878
      #
      # Michigan State -
      # ex. https://d.lib.msu.edu/maps/1084/manifest
      #
      # Minnesota
      # ex. https://cdm16022.contentdm.oclc.org/iiif/info/p16022coll205/265/manifest.json
      #
      # Nebraska -
      # ex. https://mediacommons.unl.edu/luna/servlet/iiif/m/RUMSEY~8~1~317895~90086920/manifest
      #
      # Northwestern -
      # ex. https://api.dc.library.northwestern.edu/api/v2/works/183249d3-aff6-40d5-b445-8f70addedcc3?as=iiif
      #
      # Ohio State - IIIF Manifests do not have thumbnail entries
      # ex. https://library.osu.edu/dc/concern/generic_works/9k41zr126/manifest
      #
      # Penn State -
      # ex. https://digital.libraries.psu.edu/iiif/2/maps1:30183/manifest.json
      #
      # Rutgers - No IIIF Manifests (that I know of)
      #

      ##
      # Formats and returns a thumbnail url from a IIIF Manifest
      # @param [SolrDocument]
      # @param [Integer] thumbnail size
      # @return [String] iiif thumbnail url
      def self.image_url(document, _size)
        tempfile = Down.download(document.viewer_endpoint)
        manifest_json = JSON.parse(tempfile.read)

        # Sequences - Return the first image if it exists
        # - best case option
        if manifest_json.dig("sequences", 0, "canvases", 0, "images", 0, "resource", "@id")
          Rails.logger.debug("\n Image: sequences \n")
          if manifest_json.dig("sequences", 0, "canvases", 0, "images", 0, "resource", "@id").include?("osu")
            Rails.logger.debug("\n Image: sequences - OSU variant \n")
            manifest_json.dig("sequences", 0, "canvases", 0, "images", 0, "resource", "service", "@id") + "/full/1000,/0/default.jpg"
          else
            manifest_json.dig("sequences", 0, "canvases", 0, "images", 0, "resource", "@id")
          end

        # Items - Return the first item image if it exists
        # - Northwestern
        elsif manifest_json.dig("items", 0, "items", 0, "items", 0, "body", "id")
          Rails.logger.debug("\n Image: items body id \n")
          manifest_json.dig("items", 0, "items", 0, "items", 0, "body", "id")

        # Items - Return the first item image if it exists
        # - strange option
        elsif manifest_json.dig("items", 0, "items", 0, "items", 0, "id")
          Rails.logger.debug("\n Image: items id \n")
          manifest_json.dig("items", 0, "items", 0, "items", 0, "id")

        # Thumbnail - Return the "thumbnail" if it exists
        # - varies in size depending on the provider
        # - worst case option really
        # - can be @id or id
        elsif manifest_json["thumbnail"]
          Rails.logger.debug("\n Image: thumbnail \n")
          if manifest_json.dig("thumbnail", "@id")
            manifest_json.dig("thumbnail", "@id")
          else
            manifest_json.dig("thumbnail", "id")
            manifest_json.dig("thumbnail", "id")
          end

        # Fail - Gonna fail
        else
          Rails.logger.debug("\n Image: failed \n")
          document.viewer_endpoint
        end
      rescue => e
        Rails.logger.debug("\n Rescued: #{e.inspect} \n")
        document.viewer_endpoint
      end
    end
  end
end

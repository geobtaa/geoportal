# frozen_string_literal: true

require "addressable/uri"

module GeoblacklightAdmin
  class ImageService
    attr_reader :document
    attr_writer :metadata, :logger

    def initialize(document)
      @document = document

      # State Machine
      @metadata = {}
      @metadata["solr_doc_id"] = document.id
      @metadata["placeheld"] = false
      @document.thumbnail_state_machine.transition_to!(:processing, @metadata)

      # Logger
      @logger ||= ActiveSupport::TaggedLogging.new(
        Logger.new(
          Rails.root.join("log", "image_service_#{Rails.env}.log")
        )
      )
    end

    # Stores the document's image in ActiveStorage
    # @return [Boolean]
    #
    def store
      # Gentle hands
      sleep(1)

      io_file = image_tempfile(@document.id)

      if io_file.nil? || @metadata["placeheld"] == true
        @metadata["IO"] = "NIL"
        @document.thumbnail_state_machine.transition_to!(:placeheld, @metadata)
      else
        attach_io(io_file)
      end

      log_output
    rescue => e
      @metadata["exception"] = e.inspect
      @document.thumbnail_state_machine.transition_to!(:failed, @metadata)
      log_output
    end

    private

    def image_tempfile(document_id)
      @metadata["viewer_protocol"] = @document.viewer_protocol
      @metadata["image_url"] = image_url

      return nil unless image_data && @metadata["placeheld"] == false

      temp_file = Tempfile.new("#{document_id}.tmp")
      temp_file.binmode
      temp_file.write(image_data)
      temp_file.rewind

      @metadata["image_tempfile"] = temp_file.inspect
      temp_file
    end

    def attach_io(io)
      @document.document_assets.where("json_attributes->>'thumbnail' = ?", "true").destroy_all

      content_type = Marcel::MimeType.for(File.open(io))
      @metadata["content_type"] = content_type.inspect

      if content_type.start_with?("image")
        @metadata["storing_image"] = io.inspect

        asset = Asset.new
        asset.parent_id = @document.id
        asset.file = io
        asset.title = (asset.file&.original_filename || "Untitled")
        asset.thumbnail = true
        asset.save

        @document.thumbnail_state_machine.transition_to!(:succeeded, @metadata)
      else
        @document.thumbnail_state_machine.transition_to!(:placeheld, @metadata)
      end
    end

    # Returns geoserver auth credentials if the document is a restriced Local WMS layer.
    def geoserver_credentials
      return unless restricted_wms_layer?

      Settings.PROXY_GEOSERVER_AUTH&.gsub("Basic ", "")
    end

    def restricted_wms_layer?
      @document.local_restricted? && @document.viewer_protocol == "wms"
    end

    # Tests if geoserver credentials are set beyond the default.
    def geoserver_credentials_valid?
      Settings.PROXY_GEOSERVER_AUTH != "Basic base64encodedusername:password"
    end

    # Tests if local thumbnail method is configured
    def gblsi_thumbnail_field?
      Settings.GBLSI_THUMBNAIL_FIELD
    end

    def gblsi_thumbnail_uri
      if gblsi_thumbnail_field? && @document.send(Settings.GBLSI_THUMBNAIL_FIELD).present?
        @document.send(Settings.GBLSI_THUMBNAIL_FIELD)
      else
        false
      end
    end

    # Generates hash containing thumbnail mime_type and image.
    def image_data
      return nil unless image_url

      remote_image
    end

    # Gets thumbnail image from URL. On error, placehold image.
    def remote_image
      auth = geoserver_credentials

      uri = Addressable::URI.parse(image_url)

      return nil unless uri.scheme.include?("http")

      conn = Faraday.new(url: uri.normalize.to_s) do |b|
        b.use Geoblacklight::FaradayMiddleware::FollowRedirects
        b.adapter :net_http
      end

      conn.options.timeout = timeout
      conn.authorization :Basic, auth if auth
      conn.get.body
    rescue Faraday::ConnectionFailed
      @metadata["error"] = "Faraday::ConnectionFailed"
      @metadata["placeheld"] = true
      nil
    rescue Faraday::TimeoutError
      @metadata["error"] = "Faraday::TimeoutError"
      @metadata["placeheld"] = true
      nil
    end

    # Returns the thumbnail url.
    # If the layer is restriced Local WMS, and the geoserver credentials
    # have not been set beyond the default, then a thumbnail url from
    # dct references is used instead.
    def image_url
      @image_url ||= gblsi_thumbnail_uri || service_url || image_reference
    end

    # Checks if the document is Local restriced access and is a scanned map.
    def restricted_scanned_map?
      @document.local_restricted?
    end

    # Gets the url for a specific service endpoint if the item is
    # public, has the same institution as the GBL instance, and the viewer
    # protocol is not 'map' or nil. A module name is then dynamically generated
    # from the viewer protocol, and if it's loaded, the image_url
    # method is called.
    def service_url
      # Follow image_url instead
      return nil if gblsi_thumbnail_uri.present?

      @service_url ||=
        begin
          return unless @document.available?
          protocol = @document.viewer_protocol

          if protocol == "map" || protocol.nil?
            @metadata["error"] = "Unsupported viewer protocol"
            @metadata["placeheld"] = true
            return nil
          end

          "GeoblacklightAdmin::ImageService::#{protocol.to_s.camelcase}".constantize.image_url(@document, image_size)
        rescue NameError
          @metadata["error"] = "service_url NameError"
          @metadata["placeheld"] = true
          return nil
        end
    end

    # Retreives a url to a static thumbnail from the document's dct_references field, if it exists.
    def image_reference
      @document.distributions["http://schema.org/thumbnailUrl"]
    end

    # Default image size.
    def image_size
      1500
    end

    # Faraday timeout value.
    def timeout
      30
    end

    # Capture metadata within image harvest log
    def log_output
      @metadata.each do |key, value|
        @logger.tagged(@document.id, key.to_s) { @logger.info value }
      end
    end
  end
end

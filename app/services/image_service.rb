# frozen_string_literal: true

require 'rack/mime'

class ImageService
  def initialize(document)
    @document = document
    @document.sidecar.state_machine.transition_to!(:processing)
    @metadata = Hash.new
    @logger ||= ActiveSupport::TaggedLogging.new(
      Logger.new(
        File.join(
          Rails.root, '/log/', "image_service_#{Rails.env}.log"
        )
      )
    )
  end

  # Stores the document's image in SolrDocumentSidecar
  # using Carrierwave
  # @return [Boolean]
  #
  # @TODO: EWL
  def store
    sidecar = @document.sidecar
    sidecar.image = image_tempfile(@document.id)
    sidecar.save!
    @metadata['sidecar_image_url'] = @document.sidecar.image_url
    @document.sidecar.state_machine.transition_to!(:succeeded, @metadata)
    log_output
  rescue ActiveRecord::RecordInvalid, FloatDomainError => invalid
    @metadata['exception'] = invalid.inspect
    @document.sidecar.state_machine.transition_to!(:failed,@metadata)
    log_output
  end

  def log_output
    @metadata.each do |key,value|
      @logger.tagged(@document.id, key.to_s) { @logger.info value }
    end
  end

  # Returns hash containing placeholder thumbnail for the document.
  # @return [Hash]
  #   * :type [String] image mime type
  #   * :data [String] image file data
  def placeholder
    placeholder_data
  end

  private

  def image_tempfile(document_id)
    @metadata['remote_content_type']  = remote_content_type
    @metadata['viewer_protocol']      = viewer_protocol
    @metadata['image_url']            = image_url
    @metadata['gblsi_thumbnail_uri']  = gblsi_thumbnail_uri
    @metadata['service_url']          = service_url
    @metadata['image_extension']      = image_extension

    file = Tempfile.new([document_id, image_extension])
    file.binmode
    file.write(image_data[:data])
    file.close
    file
  end

  # Returns geoserver auth credentials if the document is a restriced Local WMS layer.
  def geoserver_credentials
    return unless restricted_wms_layer?
    Settings.PROXY_GEOSERVER_AUTH.gsub('Basic ', '')
  end

  # Tests if geoserver credentials are set beyond the default.
  def geoserver_credentials_valid?
    Settings.PROXY_GEOSERVER_AUTH != 'Basic base64encodedusername:password'
  end

  # Tests if local thumbnail method is configured
  def gblsi_thumbnail_field?
    Settings.GBLSI_THUMBNAIL_FIELD
  end

  def gblsi_thumbnail_uri
    if gblsi_thumbnail_field? && @document[Settings.GBLSI_THUMBNAIL_FIELD]
      @document[Settings.GBLSI_THUMBNAIL_FIELD]
    else
      false
    end
  end

  def placeholder_base_path
    Rails.root.join('app', 'assets', 'images')
  end

  # Generates hash containing placeholder mime_type and image.
  def placeholder_data
    { type: 'image/png', data: placeholder_image }
  end

  # Gets placeholder image from disk.
  def placeholder_image
    File.read(placeholder_image_path)
  end

  # Path to placeholder image based on the layer geometry.
  def placeholder_image_path
    geom_type = @document.fetch('layer_geom_type_s', '').tr(' ', '-').downcase
    thumb_path = "#{placeholder_base_path}/thumbnail-#{geom_type}.png"
    return "#{placeholder_base_path}/thumbnail-paper-map.png" unless File.exist?(thumb_path)
    thumb_path
  end

  # Generates hash containing thumbnail mime_type and image.
  def image_data
    return placeholder_data unless image_url
    { type: remote_content_type, data: remote_image }
  end

  # Gets thumbnail image from URL. On error, returns document's placeholder image.
  def remote_content_type
    auth = geoserver_credentials

    conn = Faraday.new(url: image_url) do |b|
      b.use FaradayMiddleware::FollowRedirects
      b.adapter :net_http
    end

    conn.options.timeout = timeout
    conn.options.timeout = timeout
    conn.authorization :Basic, auth if auth

    conn.head.headers['content-type']
  rescue Faraday::Error::ConnectionFailed
    placeholder_data[:type]
  rescue Faraday::Error::TimeoutError
    placeholder_data[:type]

  # Rescuing Exception intentionally
  rescue Exception
    placeholder_data[:type]
  end

  # Gets thumbnail image from URL. On error, returns document's placeholder image.
  def remote_image
    uri = URI.parse(image_url)
    if uri.class.to_s.include?("HTTP")
      auth = geoserver_credentials
      conn = Faraday.new(url: image_url)
      conn.options.timeout = timeout
      conn.options.timeout = timeout
      conn.authorization :Basic, auth if auth

      conn.get.body
    else
      return nil
    end
  rescue Faraday::Error::ConnectionFailed
    placeholder_image
  rescue Faraday::Error::TimeoutError
    placeholder_image
  end

  # Returns the thumbnail url.
  # If the layer is restriced Local WMS, and the geoserver credentials
  # have not been set beyond the default, then a thumbnail url from
  # dct references is used instead.
  def image_url
    @image_url ||= begin
      if gblsi_thumbnail_uri
        gblsi_thumbnail_uri
      elsif restricted_scanned_map?
        image_reference
      elsif restricted_wms_layer? && !geoserver_credentials_valid?
        image_reference
      else
        service_url || image_reference
      end
    end
  end

  # Determines the image file extension
  def image_extension
    @image_extension ||= Rack::Mime::MIME_TYPES.rassoc(remote_content_type).try(:first) || '.png'
  end

  # Checks if the document is Local restriced access and is a scanned map.
  def restricted_scanned_map?
    @document.local_restricted? && @document['layer_geom_type_s'] == 'Image'
  end

  # Checks if the document is Local restriced access and is a wms layer.
  def restricted_wms_layer?
    @document.local_restricted? && @document.viewer_protocol == 'wms'
  end

  # Gets the url for a specific service endpoint if the item is
  # public, has the same institution as the GBL instance, and the viewer
  # protocol is not 'map' or nil. A module name is then dynamically generated
  # from the viewer protocol, and if it's loaded, the image_url
  # method is called.
  def service_url
    @service_url ||= begin
      return unless @document.available?
      protocol = @document.viewer_protocol
      return if protocol == 'map' || protocol.nil?
      "ImageService::#{protocol.camelcase}".constantize.image_url(@document, image_size)
    rescue NameError
      return nil
    end
  end

  def viewer_protocol
    @document.viewer_protocol
  end

  # Retreives a url to a static thumbnail from the document's dct_references field, if it exists.
  def image_reference
    return nil if @document[@document.references.reference_field].nil?
    JSON.parse(@document[@document.references.reference_field])['http://schema.org/thumbnailUrl']
  end

  # Default thumbnail size.
  def image_size
    300
  end

  # Faraday timeout value.
  def timeout
    30
  end
end

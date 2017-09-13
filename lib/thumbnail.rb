class Thumbnail
  def initialize(document)
    @document = document
  end

  ##
  # Get the thumbnail url from dctrefs if turned on in settings.
  # If not in dctrefs, then get it from a service endpoint (WMS, IIIF, etc...).
  # Return nil if both of those fail, so the thumbnail is not displayed.
  # @return [String, nil] thumbnail url
  def url
    if Settings.THUMBNAIL.USE_DCT_REFS
      thumbnail_reference || generated_thumbnail
    elsif restricted_scanned_map?
      thumbnail_reference
    else
      generated_thumbnail
    end
  end

  # Checks if the document is has restriced access and is a scanned map
  # @return [Boolean]
  def restricted_scanned_map?
    @document['dc_rights_s'] == 'Restricted' && @document['layer_geom_type_s'] == 'Image'
  end

  ##
  # Default thumbnail size.
  # @return [Integer]
  def size
    Settings.THUMBNAIL.SIZE || 256
  end

  ##
  # Base path for thumbnail images.
  # @return [String] path to thumbnails
  def thumb_path
    Settings.THUMBNAIL.BASE_PATH || 'thumbnails'
  end

  ##
  # Base path for storing thumbnail images.
  # @return [String] path to thumbnail files directory
  def file_base_path
    Settings.THUMBNAIL.FILE_BASE_PATH || "#{Rails.root}/public"
  end

  ##
  # Base thumbnail file name.
  # @return [String] thumbnail name
  def name
    (@document['layer_slug_s']).to_s
  end

  ##
  # Thumbnail path with file name and extension.
  # @return [String] path to thumbnail
  def thumb_path_and_name
    "#{thumb_path}/#{pair_path}/#{name}.jpg"
  end

  ##
  # Path to thumbnail file on server.
  # @return [String] path to thumbnail file
  def file_path_and_name
    "#{file_base_path}/#{thumb_path_and_name}"
  end

  ##
  # Creates MD5 hash of thumbnail name and
  # uses it to create a pair-tree directory path.
  # @return [String] pair-tree path for thumbnail
  def pair_path
    Digest::MD5.hexdigest(name).split('').each_slice(2).map(&:join).join('/')
  end

  ##
  # Checks if the thumbnail image already exists.
  # @return [Boolean]
  def file_exists?
    File.file?(file_path_and_name)
  end

  ##
  # Checks if the thumbnail temp file exists.
  # @return [Boolean]
  def temp_file_exists?
    File.file?("#{file_path_and_name}.tmp")
  end

  ##
  # Checks if the thumbnail error file exists.
  # @return [Boolean]
  def error_file_exists?
    File.file?("#{file_path_and_name}.error")
  end

  ##
  # Retreives thumbnail url from dct_references if it exists.
  # @return [String, nil] thumbnail url from dct_references
  def thumbnail_reference
    JSON.parse(@document[@document.references.reference_field])['http://schema.org/thumbnailUrl']
  end

  ##
  # Returns url to a generated thumbnail. If the thumbnail is already cached locally,
  # the url points to that file. If there is a file with a ".tmp" extension,
  # it is in the process of being generated and the url points to it's original
  # service endpoint. If there is a file with a ".error" extension, the url
  # is set to nil so the thumbnail is not dispayed. If no file already exits, a
  # save thumbnail job is triggered and the url points to the original service
  # endpoint.
  # @return [String, nil] url that points to a generated thumbnail
  def generated_thumbnail
    if file_exists?
      thumb_path_and_name
    elsif temp_file_exists?
      service_url
    elsif error_file_exists?
      nil
    else
      save_thumbnail unless service_url.nil?
      service_url
    end
  end

  ##
  # Gets the thumbnail url for a specific service endpoint if the item is
  # public, has the same institution as the GBL instance, and the viewer
  # protocol is not 'map' or nil. A module name is then dynamically generated
  # from the viewer protocol, and if it's loaded, the thumbnail_url
  # method is called.
  # @return [String, nil] url for generating a thumbnail
  def service_url
    return unless @document.available?
    protocol = @document.viewer_protocol
    return if protocol == 'map' || protocol.nil?
    "#{protocol.camelcase}Thumbnail".constantize.thumbnail_url(@document, size)
  rescue NameError
    return nil
  end

  ##
  # Creates a new thread which saves a local copy of a
  # generated thumbnail in the background.
  # @return [String] url for that points to service endpoint
  def save_thumbnail
    PersistThumbnailJob.perform_later(url: service_url,
                                      file_path: file_path_and_name,
                                      content_type: 'image/jpeg',
                                      timeout: 60)
  end
end

# frozen_string_literal: true

module WmsRewriteConcern
  extend Geoblacklight::SolrDocument

  def viewer_endpoint
    if local_restricted?
      # replace wms prefix with cas authed proxy
      super.gsub(Settings.INSTITUTION_GEOSERVER_URL, Settings.PROXY_GEOSERVER_URL)
    else
      super
    end
  end

  def local_restricted?
    local? && restricted?
  end

  def local?
    fetch(:dct_provenance_s, '').casecmp(Settings.INSTITUTION_LOCAL_NAME).zero?
  end
end

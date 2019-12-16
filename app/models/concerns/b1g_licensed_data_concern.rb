# frozen_string_literal: true

module B1gLicensedDataConcern
  extend Geoblacklight::SolrDocument

  # Parse stringified JSON values
  #
  # Return Hash of university code keyed proxy hyperlink values 
  def access_links
    JSON.parse(fetch(:b1g_access_s, ''))
  rescue
    return {}
  end
end

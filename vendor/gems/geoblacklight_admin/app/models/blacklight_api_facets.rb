# frozen_string_literal: true

require "httparty"

# BlacklightApiFacets
class BlacklightApiFacets
  include HTTParty

  def initialize(request)
    @request = request
  end

  def fetch
    @fetch ||= self.class.get("#{@request}#{BLACKLIGHT_JSON_API_FACETS}", query: {})
  end

  def facets
    fetch["included"].select { |s| s["type"] == "facet" } if fetch["included"].present?
  end
end

# frozen_string_literal: true

# Admin::SearchController
# This controller handles search-related actions for the admin interface.
module Admin
  class SearchController < Admin::AdminController
    # GET /admin/search
    #
    # This action sets up the request URL and retrieves facet options
    # from the Blacklight API.
    #
    # @return [void]
    def index
      @request = "#{request.protocol}#{request.host}:#{request.port}"
      @facet_options = BlacklightApiFacets.new(@request).facets
    end
  end
end

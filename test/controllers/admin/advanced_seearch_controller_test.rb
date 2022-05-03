require 'test_helper'

module Admin
  class AdvancedSearchControllerTest < ActionDispatch::IntegrationTest
    test "should return facet results for JSON" do
      get '/admin/advanced_search/advanced_search_facets.json'
      assert_response :success
    end
  end
end

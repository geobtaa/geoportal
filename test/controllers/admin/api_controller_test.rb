require 'test_helper'

module Admin
  class ApiControllerTest < ActionDispatch::IntegrationTest
    test "should return api results for JSON" do
      get '/admin/api.json'
      assert_response :success
    end

    test "should return facet results for JSON" do
      get '/admin/api/advanced_search_facets.json'
      assert_response :success
    end

    test "should include admin.api in solr_params" do
      default_solr_params = Admin::ApiController.blacklight_config.default_solr_params

      assert_includes(default_solr_params, 'admin.api')
    end

    test "should include gbl_suppressed_b:true" do
      get '/admin/api.json?q=b45275a9-61bd-4d5a-aa1e-ba8d6d1e26aa'
      assert_response :success

      json = JSON.parse(response.body)
      doc = json['data'].first
      suppressed = doc["attributes"]["gbl_suppressed_b"]["attributes"]["value"]

      assert(suppressed)
    end
  end
end

require 'test_helper'

module Admin
  class ApiControllerTest < ActionDispatch::IntegrationTest
    test "should return api results for JSON" do
      get '/admin/api.json'
      assert_response :success
    end

    test "should include admin.api in solr_params" do
      default_solr_params = Admin::ApiController.blacklight_config.default_solr_params

      assert_includes(default_solr_params, 'admin.api')
    end
  end
end

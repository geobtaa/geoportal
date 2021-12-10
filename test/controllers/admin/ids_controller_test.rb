require 'test_helper'

module Admin
  class IdsControllerTest < ActionDispatch::IntegrationTest
    test "should return api results for JSON" do
      get '/admin/api/ids.json'
      assert_response :success
    end

    test "should include admin.api in solr_params" do
      default_solr_params = Admin::IdsController.blacklight_config.default_solr_params

      assert_includes(default_solr_params, 'admin.api')
    end

    test "data array should include just ids" do
      get '/admin/api/ids.json'
      assert_response :success

      json = JSON.parse(response.body)
      doc = json['data'].first

      assert_equal(doc.keys, ["id"])
    end
  end
end

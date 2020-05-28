require 'test_helper'

module Admin
  class ApiControllerTest < ActionDispatch::IntegrationTest
    test "should return api results for JSON" do
      get '/admin/api.json'
      assert_response :success
    end
  end
end

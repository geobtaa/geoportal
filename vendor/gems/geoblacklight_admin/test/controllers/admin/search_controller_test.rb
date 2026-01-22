# test/controllers/admin/search_controller_test.rb
require "test_helper"

module Admin
  class SearchControllerTest < ActionDispatch::IntegrationTest
    setup do
      get "/users/sign_in"
      sign_in_as users(:user_001)
      post user_session_url

      follow_redirect!
      assert_response :success
    end

    test "should get index" do
      get admin_search_url
      assert_response :success
    end
  end
end

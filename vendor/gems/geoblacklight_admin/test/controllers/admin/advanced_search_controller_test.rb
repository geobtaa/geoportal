# test/controllers/admin/advanced_search_controller_test.rb
require "test_helper"

module Admin
  class AdvancedSearchControllerTest < ActionDispatch::IntegrationTest
    include ::BlacklightHelper

    setup do
      get "/users/sign_in"
      sign_in_as users(:user_001)
      post user_session_url

      follow_redirect!
      assert_response :success
    end

    test "should get facets" do
      get admin_advanced_search_facets_url, as: :json
      assert_response :success
    end
  end
end

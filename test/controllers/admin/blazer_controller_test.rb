require 'test_helper'

module Admin
  class BlazerControllerTest < ActionDispatch::IntegrationTest

    setup do
      get "/users/sign_in"
      sign_in_as users(:user_001)
      post user_session_url
  
      follow_redirect!
      assert_response :success
    end

    test "should return blazer dashboard" do
      get '/admin/blazer'
      assert_response :success
    end
  end
end

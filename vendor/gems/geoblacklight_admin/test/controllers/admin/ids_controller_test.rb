# frozen_string_literal: true

require "test_helper"

module Admin
  class IdsControllerTest < ActionDispatch::IntegrationTest
    include ::BlacklightHelper

    setup do
      get "/users/sign_in"
      sign_in_as users(:user_001)
      post user_session_url

      follow_redirect!
      assert_response :success
    end

    test "should get ids" do
      get admin_api_ids_url, as: :json
      assert_response :success
    end
  end
end

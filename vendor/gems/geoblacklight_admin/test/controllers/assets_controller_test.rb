# frozen_string_literal: true

require "test_helper"

class AssetsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    get "/users/sign_in"
    sign_in_as users(:user_001)
    post user_session_url

    follow_redirect!
    assert_response :success
  end

  test "should render assets index view" do
    get admin_assets_url
    assert_response :success
  end
end

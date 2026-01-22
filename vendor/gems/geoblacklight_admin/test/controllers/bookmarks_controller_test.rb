# frozen_string_literal: true

require "test_helper"

class BookmarksControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    get "/users/sign_in"
    sign_in_as users(:user_001)
    post user_session_url

    follow_redirect!
    assert_response :success
  end

  test "should render bookmarks index view" do
    get admin_bookmarks_url
    assert_response :success
  end

  test "should render bookmarks#index as csv" do
    get admin_bookmarks_url, params: {format: "csv"}
    assert_response :success
  end
end

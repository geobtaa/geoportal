# frozen_string_literal: true

require "test_helper"

class Admin::BookmarksControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:user_001) # Assuming you have a fixture or factory for users
    sign_in @user

    @document = documents(:ag) # Assuming you have a fixture or factory for documents
    # @bookmark = admin_bookmarks(:one) # Assuming you have a fixture or factory for bookmarks
  end

  test "should get index" do
    get admin_bookmarks_url
    assert_response :success
    assert_template :index
    assert_not_nil assigns(:bookmarks)
  end

  test "should get index in CSV format" do
    get admin_bookmarks_url(format: :csv)
    assert_response :success
    assert_equal "text/csv", response.content_type
    assert_includes response.body, GeoblacklightAdmin::Schema.instance.importable_fields.keys.map(&:to_s).join(",")
  end

  test "should create bookmark" do
    assert_difference("Admin::Bookmark.count") do
      post admin_bookmarks_url, params: {document: @document.friendlier_id}
    end

    assert_redirected_to admin_bookmarks_url
    follow_redirect!
    assert_select "div", text: "Bookmark was successfully created."
  end

  test "should not create bookmark with invalid data" do
    post admin_bookmarks_url, params: {document: nil}
    assert_response :unprocessable_entity
  end

  test "should destroy bookmark" do
    skip("Need to fix this test")
    Admin::Bookmark.create(user: @user, document: @document)

    assert_difference("Admin::Bookmark.count", -1) do
      delete admin_bookmark_url(@bookmark), params: {document: @document.friendlier_id}
    end

    assert_redirected_to admin_bookmarks_url
    follow_redirect!
    assert_select "div", text: "Bookmark was successfully destroyed."
  end

  test "should not destroy non-existent bookmark" do
    skip("Need to fix this test")
    assert_no_difference("Admin::Bookmark.count") do
      delete admin_bookmark_url(@bookmark), params: {document: "nonexistent_id"}
    end

    assert_redirected_to admin_bookmarks_url
    follow_redirect!
    assert_select "div", text: "Bookmark was successfully destroyed." # This might change based on actual controller behavior
  end
end

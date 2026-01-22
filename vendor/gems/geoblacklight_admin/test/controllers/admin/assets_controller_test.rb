# frozen_string_literal: true

require "test_helper"

module Admin
  class AssetsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @asset = assets(:asset_1)

      get "/users/sign_in"
      sign_in_as users(:user_001)
      post user_session_url

      follow_redirect!
      assert_response :success
    end

    test "should get index" do
      get admin_assets_url
      assert_response :success
      assert_not_nil assigns(:assets)
    end

    test "should show asset" do
      get admin_asset_path(@asset.id)
      assert_response :success
    end

    test "should get edit" do
      get edit_admin_asset_url(@asset.id)
      assert_response :success
    end

    test "should update asset" do
      patch admin_asset_url(@asset.id), params: {asset: {parent_id: @asset.parent_id}}
      assert_redirected_to admin_asset_url(@asset.id)
      assert_equal "Asset was successfully updated.", flash[:notice]
    end

    test "should destroy asset" do
      assert_difference("Asset.count", -1) do
        delete admin_asset_url(@asset.id)
      end

      assert_redirected_to admin_assets_url
      assert_equal "Asset was successfully destroyed.", flash[:notice]
    end

    test "should display attach form" do
      get display_attach_form_admin_assets_url
      assert_response :success
    end

    test "should attach files" do
      skip "Need a image fixture to test this properly"
      files = ["{\"id\":\"asset/82e5df8e7843b9e0c7a1420ad30b3f56.jpg\",\"storage\":\"cache\",\"metadata\":{\"filename\":\"albertsons_2k.jpg\",\"size\":858270,\"mime_type\":\"image/jpeg\",\"width\":2135,\"height\":2470}}"]
      post attach_files_admin_assets_url, params: {cached_files: files}
      assert_redirected_to admin_assets_url
      assert_equal "Files attached successfully.", flash[:notice]
    end

    private

    # Set up the necessary data for the tests
    def setup_data
      @asset = assets(:asset_1) # Ensure you have appropriate fixtures or factories
    end
  end
end

# test/controllers/admin/document_assets_controller_test.rb
require "test_helper"

module Admin
  class DocumentAssetsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @document = documents(:ag)
      @asset = assets(:asset_1)
      @document_asset = assets(:asset_1)
      @asset_params = {title: "Updated Title"}
      @file_params = {"id" => "file1", "metadata" => {"filename" => "test_file.txt"}}

      sign_in_as users(:user_001)
      post user_session_url

      follow_redirect!
      assert_response :success
    end

    test "should get index" do
      get admin_document_document_assets_url(@document)
      assert_response :success
    end

    test "should show document asset" do
      skip "@TODO: Implement Show Document Asset"
      get admin_document_document_asset_url(@document, @asset)
      assert_response :success
      assert_select "h1", @asset.title # Adjust based on your view
    end

    test "should get edit" do
      get edit_admin_document_document_asset_url(@document, @asset)
      assert_response :success
      assert_select "form" # Adjust based on your view
    end

    test "should update document_asset" do
      patch admin_document_document_asset_url(@document, @document_asset), params: {asset: @asset_params}
      assert_redirected_to admin_document_document_assets_url(@document)
      @document_asset.reload
      assert_equal "Updated Title", @document_asset.title
    end

    test "should destroy asset" do
      assert_difference("Asset.count", -1) do
        delete admin_document_document_asset_url(@document, @asset)
      end

      assert_redirected_to admin_document_document_assets_url(@document)
    end

    test "should display attach form" do
      get display_attach_form_admin_document_document_assets_url(@document)
      assert_response :success
      assert_select "form" # Adjust based on your view
    end

    test "should attach files" do
      skip "@TODO: Implement Attach Files"
      post attach_files_admin_document_document_assets_url(@document.friendlier_id), params: {id: @document.friendlier_id, cached_files: [@file_params.to_json]}
      assert_redirected_to admin_document_document_assets_url(@document.friendlier_id)
      assert Asset.where(title: "test_file.txt").exists?
    end
  end
end

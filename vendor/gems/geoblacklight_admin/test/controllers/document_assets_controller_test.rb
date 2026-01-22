require "test_helper"

class DocumentAssetsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @document = documents(:ag)
    @document_asset = assets(:asset_1)

    get "/users/sign_in"
    sign_in_as users(:user_001)
    post user_session_url

    follow_redirect!
    assert_response :success
  end

  test "should get index" do
    get admin_document_document_assets_url(document_id: @document.friendlier_id)
    assert_response :success
  end

  test "should show document_asset" do
    skip("@TODO - No Show action in DocumentAssetsController")
    get admin_document_document_asset_url(@document.friendlier_id, @document_asset.friendlier_id)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_document_document_asset_url(@document.friendlier_id, @document_asset.friendlier_id)
    assert_response :success
  end

  test "should update document_asset" do
    patch admin_document_document_asset_url(@document.friendlier_id, @document_asset.friendlier_id), params: {asset: {title: "Updated Title"}}
    assert_redirected_to admin_document_document_assets_url(@document.friendlier_id)
  end

  test "should destroy document_asset" do
    assert_difference("Asset.count", -1) do
      delete admin_document_document_asset_url(@document.friendlier_id, @document_asset.friendlier_id)
    end
    assert_redirected_to admin_document_document_assets_url(@document.friendlier_id)
  end

  test "should display attach form" do
    get display_attach_form_admin_document_document_assets_url(document_id: @document.friendlier_id)
    assert_response :success
  end

  test "should attach files" do
    skip("@TODO - Need real file_data")
    post attach_files_admin_document_document_assets_url(@document.friendlier_id), params: {id: @document.friendlier_id, cached_files: [file_data]}
    assert_redirected_to admin_document_document_assets_url(@document.friendlier_id, anchor: "nav-members")
  end

  private

  def file_data
    {"metadata" => {"filename" => "test_file.txt"}, "id" => "1"}.to_json
  end
end

# frozen_string_literal: true

require "test_helper"

class DocumentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @document = documents(:ag)

    @document_params = {
      title: "DocumentControllerTest",
      publication_state: "draft",
      gbl_resourceClass_sm: ["Dataset"],
      dct_accessRights_s: "Public",
      geomg_id_s: "1234567"
    }

    get "/users/sign_in"
    sign_in_as users(:user_001)
    post user_session_url

    follow_redirect!
    assert_response :success
  end

  test "redirects when not logged in" do
    sign_out_as :user_001
    get admin_documents_url
    assert_redirected_to new_user_session_path
  end

  test "should render documents index view" do
    get admin_documents_url
    assert_response :success
  end

  test "should redirect document show view" do
    get "/admin/documents/35c8a641589c4e13b7aa11e37f3f00a1_0"
    assert_redirected_to edit_admin_document_path
  end

  test "should render document#show as csv" do
    get "/admin/documents/35c8a641589c4e13b7aa11e37f3f00a1_0.csv"
    assert_response :success
  end

  test "should render document#show as json_gbl_v1" do
    get "/admin/documents/35c8a641589c4e13b7aa11e37f3f00a1_0.json_gbl_v1"
    assert_response :success
  end

  test "should render document#show as json_btaa_aardvark" do
    get "/admin/documents/35c8a641589c4e13b7aa11e37f3f00a1_0.json_btaa_aardvark"
    assert_response :success
  end

  test "should render document#show as json_aardvark" do
    get "/admin/documents/35c8a641589c4e13b7aa11e37f3f00a1_0.json_aardvark"
    assert_response :success
  end

  test "should render document edit view" do
    get "/admin/documents/35c8a641589c4e13b7aa11e37f3f00a1_0/edit"
    assert_response :success
  end

  test "should render documents#index as json" do
    get admin_documents_url, params: {format: "json"}
    assert_response :success
  end

  test "should render documents#index as json_gbl_v1" do
    get admin_documents_url, params: {format: "json_gbl_v1"}
    assert_response :success
  end

  test "should render documents#index as json_btaa_aardvark" do
    get admin_documents_url, params: {format: "json_btaa_aardvark"}
    assert_response :success
  end

  test "should render documents#index as json_aardvark" do
    get admin_documents_url, params: {format: "json_aardvark"}
    assert_response :success
  end

  test "should render documents#index as json_file" do
    get admin_documents_url, params: {format: "json_file"}
    assert_response :success
  end

  test "should render documents#index as csv" do
    get admin_documents_url, params: {format: "csv"}
    assert_response :success
  end

  test "should render documents#index as csv_document_licensed_access_links" do
    get admin_documents_url, params: {format: "csv_document_licensed_access_links"}
    assert_response :success
  end

  test "should map documents/:id/versions to documents#versions" do
    get "/admin/documents/35c8a641589c4e13b7aa11e37f3f00a1_0/versions"
    assert_response :success
  end

  test "should create document" do
    assert_difference("Document.count") do
      post admin_documents_url, params: {document: @document_params}
    end

    assert_redirected_to edit_admin_document_path(Document.where(friendlier_id: "1234567").first)
    follow_redirect!
    assert_select "div", text: "Document was successfully created."
  end

  test "should not create document with invalid data" do
    post admin_documents_url, params: {document: @document_params.merge(title: "")}
    assert_response :unprocessable_entity
    assert_template :edit
  end

  test "should update document" do
    patch admin_document_url(@document), params: {document: {title: "Updated Title"}}
    assert_redirected_to edit_admin_document_path(@document)
    follow_redirect!
    assert_select "div", text: "Document was successfully updated."
    @document.reload
    assert_equal "Updated Title", @document.title
  end

  test "should not update document with invalid data" do
    patch admin_document_url(@document), params: {document: {title: ""}}
    assert_response :unprocessable_entity
    assert_template :edit
  end

  test "should destroy document" do
    assert_difference("Document.count", -1) do
      delete admin_document_url(@document)
    end

    assert_redirected_to admin_documents_url
    follow_redirect!
    assert_select "div", text: "Document '#{@document.title}' was successfully destroyed."
  end

  test "should fetch documents in JSON format" do
    get fetch_admin_documents_url, params: {ids: [@document.friendlier_id]}, as: :json
    assert_response :success
    assert_not_nil JSON.parse(response.body)
  end

  test "should fetch documents in json_btaa_aardvark format" do
    get fetch_admin_documents_url, params: {ids: [@document.friendlier_id], format: :json_btaa_aardvark}
    assert_response :success
  end

  test "should fetch documents in json_aardvark format" do
    get fetch_admin_documents_url, params: {ids: [@document.friendlier_id], format: :json_aardvark}
    assert_response :success
  end

  test "should fetch documents in json_gbl_v1 format" do
    get fetch_admin_documents_url, params: {ids: [@document.friendlier_id], format: :json_gbl_v1}
    assert_response :success
  end

  test "should fetch documents in csv format" do
    get fetch_admin_documents_url, params: {ids: [@document.friendlier_id], format: :csv}
    assert_response :success
  end

  test "should fetch documents in csv_document_licensed_access_links format" do
    get fetch_admin_documents_url, params: {ids: [@document.friendlier_id], format: :csv_document_licensed_access_links}
    assert_response :success
  end

  test "should get new" do
    get new_admin_document_url
    assert_response :success
    assert_template :edit
  end
end

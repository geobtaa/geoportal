require "test_helper"

class Admin::ReferenceTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @reference_type = ReferenceType.first

    get "/users/sign_in"
    sign_in_as users(:user_001)
    post user_session_url

    follow_redirect!
    assert_response :success
  end

  test "should get index" do
    get admin_reference_types_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_reference_type_url
    assert_response :success
  end

  test "should create reference" do
    assert_difference("ReferenceType.count") do
      post admin_reference_types_url, params: {reference_type: {
        name: "new_reference_type",
        reference_type: "New Reference Type",
        reference_uri: "https://example.com"
      }}
    end

    assert_redirected_to admin_reference_type_url(ReferenceType.last)
  end

  test "should show reference_type" do
    get admin_reference_type_url(@reference_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_reference_type_url(@reference_type)
    assert_response :success
  end

  test "should update reference" do
    patch admin_reference_type_url(@reference_type), params: {reference_type: {reference_type: "Updated Reference Type"}}
    assert_redirected_to admin_reference_type_url(@reference_type)
  end

  test "should destroy reference" do
    assert_difference("ReferenceType.count", -1) do
      delete admin_reference_type_url(@reference_type)
    end

    assert_redirected_to admin_reference_types_url
  end

  test "should sort reference_types" do
    post sort_admin_reference_types_url, params: {id_list: [@reference_type.id]}
    assert_response :success
  end
end

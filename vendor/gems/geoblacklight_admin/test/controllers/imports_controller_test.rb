# frozen_string_literal: true

require "test_helper"

class Admin::ImportsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:user_001) # Assuming you have a fixture or factory for users
    sign_in @user

    @import = imports(:one) # Assuming you have a fixture or factory for imports
    @import_params = {
      name: "Test Import",
      filename: "test.csv",
      source: "local",
      description: "A test import file",
      row_count: 100,
      encoding: "UTF-8",
      content_type: "text/csv",
      extension: "csv",
      type: "Import"
    }
  end

  test "should get index" do
    get admin_imports_url
    assert_response :success
    assert_template :index
    assert_not_nil assigns(:imports)
  end

  test "should show import" do
    get admin_import_url(@import)
    assert_response :success
    assert_template :show
    assert_not_nil assigns(:import_failed_documents)
    assert_not_nil assigns(:import_success_documents)
  end

  test "should get new" do
    get new_admin_import_url
    assert_response :success
    assert_template :new
  end

  test "should get edit" do
    get edit_admin_import_url(@import)
    assert_response :success
    assert_template :edit
  end

  test "should create import" do
    skip("@TODO: add file upload to test")
    assert_difference("Import.count") do
      post admin_imports_url, params: {import: @import_params}
    end

    assert_redirected_to admin_import_mappings_path(Import.last)
    follow_redirect!
    assert_select "div", text: "Import was successful. Please set your import mapping rules."
  end

  test "should not create import with invalid data" do
    post admin_imports_url, params: {import: @import_params.merge(name: "")}
    assert_response :unprocessable_entity
    assert_template :new
  end

  test "should update import" do
    skip("@TODO: add file upload to test")
    patch admin_import_url(@import), params: {import: {name: "Updated Import"}}
    assert_redirected_to admin_import_path(@import)
    follow_redirect!
    assert_select "div", text: "Import was successfully updated."
    @import.reload
    assert_equal "Updated Import", @import.name
  end

  test "should not update import with invalid data" do
    patch admin_import_url(@import), params: {import: {name: ""}}
    assert_response :unprocessable_entity
    assert_template :edit
  end

  test "should destroy import" do
    assert_difference("Import.count", -1) do
      delete admin_import_url(@import)
    end

    assert_redirected_to admin_imports_url
    follow_redirect!
    assert_select "div", text: "Import was successfully destroyed."
  end

  test "should run import" do
    skip("@TODO: add file upload to test")
    # Stub the run! method directly on the @import instance
    @import.stub(:run!, true) do
      post run_admin_import_url(@import)
      assert_redirected_to admin_import_path(@import)
      follow_redirect!
      assert_select "div", text: "Import is running. Check back soon for results."
    end
  end
end

require "test_helper"

class ImportDistributionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:user_001) # Assuming you have a fixture or factory for users
    sign_in @user

    @import_distribution = import_distributions(:one)
  end

  test "should get index" do
    get admin_import_distributions_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_import_distribution_url
    assert_response :success
  end

  test "should create import_distribution" do
    skip("@TODO: add file upload to test")
    assert_difference("ImportDistribution.count") do
      post admin_import_distributions_url, params: {import_distribution: {name: "New Import", filename: "file.csv"}}
    end

    assert_redirected_to admin_import_distribution_url(ImportDistribution.last)
  end

  test "should show import_distribution" do
    get admin_import_distribution_url(@import_distribution)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_import_distribution_url(@import_distribution)
    assert_response :success
  end

  test "should update import_distribution" do
    skip("@TODO: add file upload to test")
    patch admin_import_distribution_url(@import_distribution), params: {import_distribution: {name: "Updated Import"}}
    assert_redirected_to admin_import_distribution_url(@import_distribution)
  end

  test "should destroy import_distribution" do
    assert_difference("ImportDistribution.count", -1) do
      delete admin_import_distribution_url(@import_distribution)
    end

    assert_redirected_to admin_import_distributions_url
  end

  test "should run import_distribution" do
    skip("@TODO: add file upload to test")
    post run_admin_import_distribution_url(@import_distribution)
    assert_redirected_to admin_import_distribution_url(@import_distribution)
  end
end

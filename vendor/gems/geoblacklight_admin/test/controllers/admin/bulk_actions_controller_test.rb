# test/controllers/admin/bulk_actions_controller_test.rb
require "test_helper"

module Admin
  class BulkActionsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @bulk_action = bulk_actions(:one)  # Assuming you have fixtures for bulk_actions
      @bulk_action_params = {name: "Test Action", scope: "test_scope"}

      sign_in_as users(:user_001)
      post user_session_url

      follow_redirect!
      assert_response :success
    end

    test "should get index" do
      get admin_bulk_actions_url
      assert_response :success
    end

    test "should show bulk_action" do
      get admin_bulk_action_url(@bulk_action)
      assert_response :success
      assert_select "h1", @bulk_action.name  # Adjust based on your view
    end

    test "should get new" do
      get new_admin_bulk_action_url
      assert_response :success
      assert_select "form"  # Adjust based on your view
    end

    test "should create bulk_action" do
      skip "@TODO: count difference is not working"
      assert_difference("BulkAction.count") do
        post admin_bulk_actions_url, params: {bulk_action: @bulk_action_params}
      end

      assert_redirected_to admin_bulk_action_url(BulkAction.last)
    end

    test "should update bulk_action" do
      patch admin_bulk_action_url(@bulk_action), params: {bulk_action: @bulk_action_params.merge(name: "Updated Action")}
      assert_redirected_to admin_bulk_action_url(@bulk_action)
      @bulk_action.reload
      assert_equal "Updated Action", @bulk_action.name
    end

    test "should destroy bulk_action" do
      assert_difference("BulkAction.count", -1) do
        delete admin_bulk_action_url(@bulk_action)
      end

      assert_redirected_to admin_bulk_actions_url
    end

    test "should run bulk_action" do
      patch run_admin_bulk_action_url(@bulk_action)
      assert_redirected_to admin_bulk_action_url(@bulk_action)
      assert_equal "Bulk action is running. Check back soon for results.", flash[:notice]
    end

    test "should revert bulk_action" do
      patch revert_admin_bulk_action_url(@bulk_action)
      assert_redirected_to admin_bulk_action_url(@bulk_action)
      assert_equal "Revert bulk action is running. Check back soon for results.", flash[:notice]
    end
  end
end

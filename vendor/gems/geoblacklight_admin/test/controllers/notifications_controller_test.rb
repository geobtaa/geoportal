# frozen_string_literal: true

require "test_helper"

class NotificationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:user_001) # Assumes a user fixture or factory is available
    @notification = notifications(:one) # Assumes a notification fixture or factory is available

    get "/users/sign_in"
    sign_in_as users(:user_001)
    post user_session_url

    follow_redirect!
    assert_response :success
  end

  test "should get index" do
    get admin_notifications_url
    assert_response :success
    assert_not_nil assigns(:notifications)
    assert_not_nil assigns(:pagy)
  end

  test "should update notification to mark as read" do
    patch admin_notification_url(@notification), params: {read: "1"}
    assert_redirected_to admin_notifications_url
    follow_redirect!
    @notification.reload
    assert_not_nil @notification.read_at
  end

  test "should update notification to mark as unread" do
    @notification.update(read_at: Time.zone.now) # Mark as read first
    patch admin_notification_url(@notification), params: {read: "0"}
    assert_redirected_to admin_notifications_url
    follow_redirect!
    @notification.reload
    assert_nil @notification.read_at
  end

  test "should destroy notification" do
    assert_difference("Notification.count", -1) do
      delete admin_notification_url(@notification)
    end
    assert_redirected_to admin_notifications_url
    follow_redirect!
    assert_equal "Notification was successfully destroyed.", flash[:notice]
  end

  test "should mark all notifications as read in batch" do
    # Create some unread notifications
    notifications = [
      Notification.create!(recipient_type: User, recipient_id: @user.id, type: ExportNotification),
      Notification.create!(recipient_type: User, recipient_id: @user.id, type: ExportNotification)
    ]

    assert_empty notifications.pluck(&:read_at).compact, "Notifications should initially be unread"

    put batch_admin_notifications_url, params: {read: "all"}
    assert_redirected_to admin_notifications_url
    follow_redirect!
    assert_equal "All notifications marked as read.", flash[:success]

    @user.notifications.each do |notification|
      assert_not_nil notification.reload.read_at, "All notifications should be marked as read"
    end
  end

  test "should handle invalid update parameters gracefully" do
    patch admin_notification_url(@notification), params: {read: "invalid"}
    assert_redirected_to admin_notifications_url
    follow_redirect!
    assert_nil flash[:notice] # No specific flash message expected for invalid params
  end
end

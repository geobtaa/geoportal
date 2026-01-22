# frozen_string_literal: true

# Admin::NotificationsController
#
# This controller manages the notifications for the admin panel. It provides
# actions to list, update, destroy, and batch update notifications.
module Admin
  class NotificationsController < Admin::AdminController
    before_action :set_notification, only: %i[update destroy]

    # GET /admin/notifications
    #
    # Lists all notifications for the current user, paginated.
    #
    # @return [void]
    def index
      @pagy, @notifications = pagy(current_user.notifications.order(created_at: :desc), items: 20)
    end

    # PATCH/PUT /admin/notifications/:id
    #
    # Updates the read status of a notification.
    #
    # @param [String] read The read status, "0" for unread, "1" for read.
    # @return [void]
    def update
      case params[:read]
      when "0"
        @notification.update(read_at: nil)
        @toast = "Notification marked unread."
      when "1"
        @notification.update(read_at: Time.zone.now)
        @toast = "Notification marked read."
      end

      respond_to do |format|
        format.html { redirect_to admin_notifications_url }
        format.js
      end
    end

    # DELETE /admin/notifications/:id
    #
    # Destroys a notification and purges its associated file.
    #
    # @return [void]
    def destroy
      @notification.file.purge
      @notification.destroy
      respond_to do |format|
        format.html { redirect_to admin_notifications_url, notice: "Notification was successfully destroyed." }
        format.json { head :no_content }
      end
    end

    # POST /admin/notifications/batch
    #
    # Marks all notifications as read.
    #
    # @return [void]
    def batch
      return unless params[:read] == "all"

      current_user.notifications.mark_as_read!
      flash[:success] = "All notifications marked as read."
      redirect_to admin_notifications_url
    end

    private

    # Sets the notification based on the provided ID.
    #
    # @return [void]
    def set_notification
      @notification = Notification.find(params[:id])
    end
  end
end

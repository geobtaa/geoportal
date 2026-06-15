# frozen_string_literal: true

# Admin::UsersController
#
# This controller handles the actions related to admin users.
# It inherits from Admin::AdminController, which provides
# common functionality for all admin-related controllers.
module Admin
  class UsersController < Admin::AdminController
    # GET /admin/users
    #
    # This action retrieves all users with admin privileges.
    # It assigns the result to the @users instance variable,
    # which can be used in the corresponding view to display
    # the list of admin users.
    def index
      @users = User.where(admin: true)
    end
  end
end

# frozen_string_literal: true

# The Admin module contains controllers for the admin section of the application.
module Admin
  # AdminController is the base controller for all admin-related controllers.
  # It includes necessary modules and provides authentication for admin users.
  class AdminController < ApplicationController
    # Includes Devise helpers for authentication.
    include Devise::Controllers::Helpers
    # Includes Pagy for pagination.
    include ::Pagy::Backend

    # Sets the layout for the admin section.
    layout "admin/layouts/application"

    # Before any action, ensure the user is authenticated as an admin.
    before_action :authenticate_admin!
    before_action :set_action_cable_identifier

    protected

    # Authenticates the user and checks if they are an admin.
    # Redirects to a specified location with a forbidden status if the user is not an admin.
    def authenticate_admin!
      authenticate_user!
      redirect_to :somewhere, status: :forbidden unless current_user.admin?
    end

    private

    def set_action_cable_identifier
      cookies.encrypted[:user_id] = current_user&.id
    end
  end
end

class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  layout 'blacklight'

  after_action :save_previous_url

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def save_previous_url
    # session[:previous_url] is a Rails built-in variable to save last url.
    session[:previous_url] = URI(request.referer || '').path
  end

  protected

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end

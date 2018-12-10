class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  layout 'blacklight'

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Appsignal Namespace for Qualys
  before_action :set_qualys_namespace

  protected

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  private
  
  def set_qualys_namespace
    qualys_ips = [
      '160.94.202.168',
      '160.94.202.169',
      '160.94.202.170',
      '160.94.202.171',
      '160.94.202.172',
      '160.94.202.173',
      '160.94.202.174',
      '160.94.202.175'
    ]
    if qualys_ips.include?(request.remote_ip)
      Appsignal.set_namespace("qualys")
    end
  end
end

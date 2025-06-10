class ErrorsController < ApplicationController
  def not_found
    render status: 404, layout: 'blacklight'
  end

  def internal_server_error
    render status: 500, layout: 'blacklight'
  end
end

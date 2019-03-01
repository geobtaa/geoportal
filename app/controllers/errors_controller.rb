# frozen_string_literal: true

class ErrorsController < ApplicationController
  def not_found
    render status: :not_found, layout: 'blacklight', template: 'errors/not_found.html.erb'
  end

  def internal_server_error
    render status: :internal_server_error, layout: 'blacklight', template: 'errors/internal_server_error.html.erb'
  end
end

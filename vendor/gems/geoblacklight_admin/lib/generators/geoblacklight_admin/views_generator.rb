# frozen_string_literal: true

require "rails/generators"

module GeoblacklightAdmin
  class ViewsGenerator < Rails::Generators::Base
    source_root File.expand_path("templates", __dir__)

    desc <<-DESCRIPTION
      This generator makes the following changes to your application:
       1. Creates an app/views/devise directory
    DESCRIPTION

    def create_views
      directory "devise", "app/views/devise", force: true
    end
  end
end

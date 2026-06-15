# frozen_string_literal: true

require "rails/generators"
require "rails/generators/migration"

module GeoblacklightAdmin
  class ModelsGenerator < Rails::Generators::Base
    include Rails::Generators::Migration

    source_root File.expand_path("templates", __dir__)

    desc <<-DESCRIPTION
      This generator makes the following changes to your application:
       1. Preps engine migrations
    DESCRIPTION

    # Setup the database migrations
    def copy_migrations
      rake "geoblacklight_admin:install:migrations"
    end
  end
end

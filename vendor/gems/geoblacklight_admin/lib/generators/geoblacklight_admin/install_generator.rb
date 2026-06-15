# frozen_string_literal: true

require "rails/generators"

module GeoblacklightAdmin
  class Install < Rails::Generators::Base
    source_root File.expand_path("templates", __dir__)

    desc "Install GeoblacklightAdmin"

    def bundle_install
      Bundler.with_unbundled_env do
        run "bundle install"
      end
    end

    def generate_gbl_admin_assets
      inject_into_file "app/assets/stylesheets/application.scss", after: "@import 'geoblacklight';\n" do
        "@import 'geoblacklight_admin/core';"
      end
    end

    def generate_gbl_admin_jobs
      generate "geoblacklight_admin:jobs"
    end

    def generate_gbl_admin_models
      generate "geoblacklight_admin:models"
    end

    def generate_gbl_admin_views
      generate "geoblacklight_admin:views"
    end

    def generate_gbl_admin_helpers
      generate "geoblacklight_admin:helpers"
    end

    def generate_gbl_admin_config
      generate "geoblacklight_admin:config"
    end

    def install_active_storage
      run "bin/rails active_storage:install"
    end

    def install_yarn
      run "yarn add @geoblacklight/frontend@^4.4.6"
      run "yarn install"
    end

    def add_rsolr_gem
      gem "rsolr", ">= 1.0", "< 3"
    end

    def docker_compose
      copy_file "../../../../compose.yml", "compose.yml"
    end
  end
end

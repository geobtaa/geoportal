# frozen_string_literal: true

require "rails/generators"

class TestAppGenerator < Rails::Generators::Base
  source_root File.expand_path("../../../../spec/test_app_templates", __FILE__)

  # if you need to generate any additional configuration
  # into the test app, this generator will be run immediately
  # after setting up the application

  def add_gems
    gem "blacklight", "~> 7.0"
    gem "geoblacklight", ">= 4.0"

    Bundler.with_unbundled_env do
      run "bundle install"
    end
  end

  def run_simple_form_generator
    say_status("warning", "GENERATING SIMPLE FORM", :yellow)
    generate "simple_form:install"
  end

  def run_blacklight_generator
    say_status("warning", "GENERATING BL", :yellow)
    generate "blacklight:install", "--devise"
  end

  def run_geoblacklight_generator
    say_status("warning", "GENERATING GBL", :yellow)
    generate "geoblacklight:install", "--force"
  end

  def run_geoblacklight_admin_generator
    say_status("warning", "GENERATING GBL Admin", :yellow)
    generate "geoblacklight_admin:install", "--force"
  end
end

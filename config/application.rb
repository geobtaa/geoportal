require_relative "boot"

require "rails/all"
require "blacklight/allmaps"


require "blacklight/allmaps/engine"
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Geoblacklight
  class Application < Rails::Application
    config.railties_order = [:main_app, Blacklight::Allmaps::Engine, :all]

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.to_prepare do
      # Load application's model / class decorators
      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    config.time_zone = 'Central Time (US & Canada)'

    # Exception Handling
    config.exceptions_app = self.routes

    # Rack::Cors / Access-Control-Allow-Origin
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :options]
      end
    end

    # Image Processing
    config.active_storage.variant_processor = :vips
  end
end

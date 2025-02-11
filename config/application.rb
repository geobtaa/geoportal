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
    config.load_defaults 7.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

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

    # YAML
    config.active_record.yaml_column_permitted_classes = %w[Symbol Time Date BigDecimal OpenStruct]
  end
end

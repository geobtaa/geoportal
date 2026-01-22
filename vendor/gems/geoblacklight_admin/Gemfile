# frozen_string_literal: true

source "https://rubygems.org"

# Declare your gem's dependencies in geoblacklight_admin.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.

# Please see geoblacklight_admin.gemspec for dependency information.
gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

group :development, :test do
end

# To use a debugger
# gem 'byebug', group: [:development, :test]

# BEGIN ENGINE_CART BLOCK
# engine_cart: 2.5.0
# engine_cart stanza: 2.5.0
# the below comes from engine_cart, a gem used to test this Rails engine gem in the context of a Rails app.
file = File.expand_path("Gemfile",
  ENV["ENGINE_CART_DESTINATION"] || ENV["RAILS_ROOT"] || File.expand_path(".internal_test_app",
    File.dirname(__FILE__)))
if File.exist?(file)
  begin
    eval_gemfile file
  rescue Bundler::GemfileError => e
    Bundler.ui.warn "[EngineCart] Skipping Rails application dependencies:"
    Bundler.ui.warn e.message
  end
else
  Bundler.ui.warn "[EngineCart] Unable to find test application dependencies in #{file}, using placeholder dependencies"
  gem "blacklight", "~> 7.33"
  gem "blacklight_advanced_search"
  gem "geoblacklight", ">= 4.0"
  gem "statesman", ">= 3.4"

  Bundler.ui.warn "[GBL‡ADMIN] Adding geoblacklight_admin dependencies"
  # GBL‡ADMIN
  gem "active_storage_validations"
  gem "awesome_print"
  gem "blacklight_advanced_search"
  gem "devise-bootstrap-views", "~> 1.0"
  gem "dotenv-rails"
  gem "haml"
  gem "inline_svg"
  gem "kithe", "~> 2.0"
  gem "noticed"
  gem "paper_trail"
  gem "simple_form", "~> 5.0"

  if ENV["RAILS_VERSION"]
    if ENV["RAILS_VERSION"] == "edge"
      gem "rails", github: "rails/rails"
      ENV["ENGINE_CART_RAILS_OPTIONS"] = "--edge --skip-turbolinks"
    else
      gem "rails", ENV["RAILS_VERSION"]
    end

    case ENV["RAILS_VERSION"]
    when /^6.0/
      gem "sass-rails", ">= 6"
    end
  end
end
# END ENGINE_CART BLOCK

gem "rails-controller-testing", "~> 1.0"
gem "webmock", "~> 3.23"

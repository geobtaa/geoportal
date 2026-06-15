# frozen_string_literal: true

require_relative "lib/geoblacklight_admin/version"

Gem::Specification.new do |s|
  s.name = "geoblacklight_admin"
  s.version = GeoblacklightAdmin::VERSION
  s.authors = ["Eric Larson"]
  s.email = ["ewlarson@gmail.com"]
  s.homepage = "https://github.com/geobtaa/geoblacklight_admin"
  s.summary = "Administrative UI for GeoBlacklight. Built on Kithe."
  s.license = "MIT"

  s.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  s.executables = s.files.grep(%r{^bin/}) { |f| File.basename(f) }

  s.add_dependency "active_storage_validations", "~> 1.0"
  s.add_dependency "amazing_print"
  s.add_dependency "blacklight", "~> 7.0"
  s.add_dependency "blacklight_advanced_search"
  s.add_dependency "blacklight_range_limit"
  s.add_dependency "bootstrap", "~> 4.0"
  s.add_dependency "chosen-rails", "~> 1.10"
  s.add_dependency "cocoon", "~> 1.2"
  s.add_dependency "config", "~> 4.0"
  s.add_dependency "devise", "~> 4.7"
  s.add_dependency "devise-bootstrap-views", "~> 1.0"
  s.add_dependency "dotenv-rails", "~> 2.8"
  s.add_dependency "geoblacklight", "~> 4.0"
  s.add_dependency "haml", "~> 5.2"
  s.add_dependency "httparty", "~> 0.21"
  s.add_dependency "inline_svg", "~> 1.9"
  s.add_dependency "jquery-rails", "~> 4.4"
  s.add_dependency "kithe", "~> 2.0"
  s.add_dependency "mutex_m", "~> 0.2.0"
  s.add_dependency "noticed", "~> 1.6"
  s.add_dependency "pagy", "~> 9.0"
  s.add_dependency "paper_trail", "~> 15.0"
  s.add_dependency "pg", "~> 1.4"
  s.add_dependency "qa", "~> 5.0"
  s.add_dependency "rails", "~> 7.0"
  s.add_dependency "ruby-progressbar"
  s.add_dependency "simple_form", "~> 5.0"
  s.add_dependency "sprockets", "~> 3.0"
  s.add_dependency "statesman", "~> 12.0"
  s.add_dependency "vite_rails", "~> 3.0"
  s.add_dependency "vite_ruby", ">= 3.5"
  s.add_dependency "zeitwerk", "~> 2.6"
  s.add_dependency "rubyzip", "~> 2.3"

  s.add_development_dependency "byebug", "~> 11.1"
  s.add_development_dependency "capybara", "~> 3.0"
  s.add_development_dependency "capybara-screenshot", "~> 1.0"
  s.add_development_dependency "database_cleaner", "~> 1.3"
  s.add_development_dependency "database_cleaner-active_record", "~> 2.1"
  s.add_development_dependency "engine_cart", "~> 2.4"
  s.add_development_dependency "m", "~> 1.5"
  s.add_development_dependency "minitest", "~> 5.18"
  s.add_development_dependency "minitest-ci", "~> 3.4"
  s.add_development_dependency "minitest-rails", "~> 7.0"
  s.add_development_dependency "minitest-reporters", "~> 1.6"
  s.add_development_dependency "mocha", "~> 2.0"
  s.add_development_dependency "rails-controller-testing", "~> 1.0"
  s.add_development_dependency "rspec-rails", "~> 3.0"
  s.add_development_dependency "selenium-webdriver", "~> 4.25"
  s.add_development_dependency "shoulda-context", "~> 2.0"
  s.add_development_dependency "simplecov", "~> 0.22"
  s.add_development_dependency "sprockets", "~> 3.0"
  s.add_development_dependency "standard", "~> 1.24"
  s.add_development_dependency "webdrivers"
  s.add_development_dependency "web-console"
  s.add_development_dependency "webmock", "~> 3.23"
end

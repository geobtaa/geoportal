ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/rails/capybara"
require 'capybara/poltergeist'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
end

# Ignore JS errors
Capybara.register_driver :poltergeist_ignore_js_errors do |app|
  Capybara::Poltergeist::Driver.new(app, {phantomjs_options: ['--ignore-ssl-errors=yes', '--ssl-protocol=TLSv1'], js_errors: false})
end

Capybara.default_driver = :poltergeist_ignore_js_errors

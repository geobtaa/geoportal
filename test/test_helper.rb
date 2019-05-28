ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'webdrivers'
require 'selenium/webdriver'
require 'capybara/dsl'
require 'capybara/rails'
require "minitest/rails/capybara"

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
end

require "selenium/webdriver"

class Capybara::Rails::TestCase < ActiveSupport::TestCase
  include Capybara::DSL
  fixtures :all

  def ran_without_js_errors
    errors = page.driver.browser.manage.logs.get(:browser).select { |m|
      m.level == 'SEVERE'
    }

    assert_equal errors.length, 0, "JS Error Detected"
  end
end

Capybara.register_driver :chrome_headless do |app|
  options = Selenium::WebDriver::Chrome::Options.new(args: %w[disable-gpu window-size=1280,1024)])
  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: options
  )
end

Capybara.app_host = ENV['REMOTE_URL'] if ENV['REMOTE_URL']
Capybara.run_server = false if ENV['REMOTE_URL']
Capybara.default_max_wait_time = 20
Capybara.javascript_driver = :chrome_headless
Capybara.default_driver = :chrome_headless

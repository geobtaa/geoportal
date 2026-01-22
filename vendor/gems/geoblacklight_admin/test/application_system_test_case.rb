# frozen_string_literal: true

require "test_helper"
require "capybara/dsl"
require "capybara-screenshot"
require "selenium-webdriver"

Capybara.register_driver :selenium_chrome_headless do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_preference("download.default_directory", Rails.root.join("tmp/downloads"))
  options.add_preference(:download, default_directory: Rails.root.join("tmp/downloads"))

  [
    "headless",
    "window-size=1920,1080",
    "disable-gpu" # https://developers.google.com/web/updates/2017/04/headless-chrome
  ].each { |arg| options.add_argument(arg) }

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options).tap do |driver|
    driver.browser.download_path = Rails.root.join("tmp/downloads")
  end
end

Capybara::Screenshot.register_driver(:selenium_chrome_headless) do |driver, path|
  driver.browser.save_screenshot(path)
end

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium_chrome_headless

  include Capybara::DSL
end

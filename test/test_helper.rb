# Configure Rails Environment
ENV['RAILS_ENV'] ||= 'test'

# SimpleCov
require "simplecov"
SimpleCov.formatter = SimpleCov::Formatter::HTMLFormatter

SimpleCov.start "rails" do
  add_filter ".internal_test_app/"
end

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require "minitest/rails"
require "minitest/reporters"

require "webmock/minitest"
WebMock.enable!
WebMock.allow_net_connect!

require 'selenium/webdriver'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  include Devise::Test::IntegrationHelpers
  include Warden::Test::Helpers

  def sign_in_as(user_or_key)
    u = user_or_key
    u = users(user_or_key) if u.is_a? Symbol
    sign_in(u)
  end

  def sign_out_as(user_or_key)
    u = user_or_key
    u = users(user_or_key) if u.is_a? Symbol
    sign_out u
  end
end

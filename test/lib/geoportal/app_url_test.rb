# frozen_string_literal: true

require "test_helper"

class GeoportalAppUrlTest < ActiveSupport::TestCase
  ENV_KEYS = %w[GEOPORTAL_APP_URL GEOPORTAL_DEFAULT_URL_HOST HOST_URL].freeze

  setup do
    @original_env = ENV_KEYS.to_h { |key| [key, ENV[key]] }
    ENV_KEYS.each { |key| ENV.delete(key) }
  end

  teardown do
    @original_env.each do |key, value|
      value.nil? ? ENV.delete(key) : ENV[key] = value
    end
  end

  test "defaults to the EC2 hostname" do
    assert_equal Geoportal::DEFAULT_APP_URL, Geoportal::AppUrl.app_url
  end

  test "uses GEOPORTAL_APP_URL with path normalization" do
    ENV["GEOPORTAL_APP_URL"] = "https://example.test/base/"

    assert_equal "https://example.test/base", Geoportal::AppUrl.app_url
    assert_equal "https://example.test/base/feedback", Geoportal::AppUrl.url("feedback")
  end

  test "accepts legacy bare host setting" do
    ENV["GEOPORTAL_DEFAULT_URL_HOST"] = "legacy.example.test"

    assert_equal "https://legacy.example.test", Geoportal::AppUrl.app_url
    assert_equal({host: "legacy.example.test", protocol: "https://"}, Geoportal::AppUrl.default_url_options)
  end

  test "keeps non-standard ports in default url options" do
    ENV["GEOPORTAL_APP_URL"] = "https://legacy.example.test:8443"

    assert_equal(
      {host: "legacy.example.test", protocol: "https://", port: 8443},
      Geoportal::AppUrl.default_url_options
    )
  end
end

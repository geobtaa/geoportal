# frozen_string_literal: true

require "uri"

module Geoportal
  DEFAULT_APP_URL = "https://ec2-3-143-166-108.us-east-2.compute.amazonaws.com"

  module AppUrl
    module_function

    def app_url
      configured_url.delete_suffix("/")
    end

    def url(path = nil)
      return app_url if path.nil? || path.to_s.empty?

      normalized_path = path.to_s
      normalized_path = "/#{normalized_path}" unless normalized_path.start_with?("/")

      "#{app_url}#{normalized_path}"
    end

    def default_url_options
      uri = URI.parse(app_url)
      options = {host: uri.host, protocol: "#{uri.scheme}://"}
      options[:port] = uri.port unless [80, 443].include?(uri.port)
      options
    end

    def configured_url
      value = first_present_env("GEOPORTAL_APP_URL", "GEOPORTAL_DEFAULT_URL_HOST", "HOST_URL") || DEFAULT_APP_URL
      value.match?(%r{\Ahttps?://}) ? value : "https://#{value}"
    end

    def first_present_env(*keys)
      keys.each do |key|
        value = ENV[key].to_s.strip
        return value unless value.empty?
      end

      nil
    end
  end
end

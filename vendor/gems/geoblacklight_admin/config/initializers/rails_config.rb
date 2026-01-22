# frozen_string_literal: true

Config.setup do |config|
  config.const_name = "Settings"
end

Settings.prepend_source!(File.expand_path("defaults.yml", __dir__))
Settings.reload!

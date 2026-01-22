# frozen_string_literal: true

require "active_support/dependencies"
require "geoblacklight_admin/engine"
require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.ignore("#{__dir__}/generators")
loader.setup

module GeoblacklightAdmin
end

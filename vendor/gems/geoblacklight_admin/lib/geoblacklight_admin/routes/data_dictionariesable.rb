# frozen_string_literal: true

module GeoblacklightAdmin
  module Routes
    class DataDictionariesable
      def initialize(defaults = {})
        @defaults = defaults
      end

      def call(mapper, _options = {})
        mapper.member do
          mapper.get "data_dictionaries"
        end
      end
    end
  end
end

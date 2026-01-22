# frozen_string_literal: true

require "statesman"

Statesman.configure do
  storage_adapter(Statesman::Adapters::ActiveRecord)
end

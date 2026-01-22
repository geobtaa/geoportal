# frozen_string_literal: true

require "test_helper"

class BulkActionDocumentStateMachineTest < ActiveSupport::TestCase
  test "states" do
    assert_equal(BulkActionDocumentStateMachine.states, %w[created queued success failed])
  end
end

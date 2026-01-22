# frozen_string_literal: true

require "test_helper"

class ImportDocumentDistributionStateMachineTest < ActiveSupport::TestCase
  test "states" do
    assert_equal(ImportDocumentDistributionStateMachine.states, %w[queued success failed])
  end
end

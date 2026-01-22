# frozen_string_literal: true

require "test_helper"

class ImportStateMachineTest < ActiveSupport::TestCase
  test "states" do
    assert_equal(ImportStateMachine.states, %w[created mapped imported success failed])
  end
end

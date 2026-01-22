# frozen_string_literal: true

require "test_helper"

class DocumentThumbnailStateMachineTest < ActiveSupport::TestCase
  test "states" do
    assert_equal(DocumentThumbnailStateMachine.states, %w[initialized queued processing succeeded failed placeheld])
  end
end

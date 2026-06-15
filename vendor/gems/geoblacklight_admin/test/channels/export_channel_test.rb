# frozen_string_literal: true

require "test_helper"

class ExportChannelTest < ActionCable::Channel::TestCase
  # Test subscribing to the ExportChannel
  test "subscribes to stream" do
    subscribe

    # Asserts that the subscription was successfully created
    assert subscription.confirmed?

    # Asserts that the subscription streams from the correct channel
    assert_has_stream "export_channel"
  end

  # Test unsubscribing from the ExportChannel
  test "unsubscribes from stream" do
    subscribe

    # Assert that the subscription was confirmed and streaming from the channel
    assert subscription.confirmed?
    assert_has_stream "export_channel"

    # Perform unsubscribe action
    unsubscribe

    # Assert that the channel is no longer streaming
    assert_no_streams
  end
end

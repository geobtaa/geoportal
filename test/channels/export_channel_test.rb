require 'test_helper'

class ExportChannelTest < ActionCable::Channel::TestCase
  test "subscribes to export_channel" do
    subscribe
    assert subscription.confirmed?
    assert_has_stream 'export_channel'
  end

  test "unsubscribes from export_channel" do
    subscribe
    assert subscription.confirmed?
    
    unsubscribe
    assert_no_streams
  end
end
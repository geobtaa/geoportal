require 'test_helper'

module ApplicationCable
  class ChannelTest < ActiveSupport::TestCase
    test "should be a subclass of ActionCable::Channel::Base" do
      assert Channel < ActionCable::Channel::Base
    end

    test "should be defined within ApplicationCable module" do
      assert_equal ApplicationCable::Channel, Channel
    end

    test "can be instantiated with connection and identifier" do
      connection = Object.new
      def connection.identifiers
        [:test_identifier]
      end
      identifier = "test_channel"
      assert_nothing_raised do
        Channel.new(connection, identifier)
      end
    end
  end
end
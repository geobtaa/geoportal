require 'test_helper'

module ApplicationCable
  class ConnectionTest < ActionCable::Connection::TestCase
    def setup
      @user = User.create(email: 'test@example.com', password: 'password')
    end

    test "connects with authenticated user" do
      # Simulate Devise authentication
      warden = Minitest::Mock.new
      warden.expect :user, @user

      connect env: { 'warden' => warden }

      assert_equal @user, connection.current_user
    end

    test "rejects connection without authenticated user" do
      # Simulate no authenticated user
      warden = Minitest::Mock.new
      warden.expect :user, nil

      assert_reject_connection { connect env: { 'warden' => warden } }
    end
  end
end
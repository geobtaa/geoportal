# frozen_string_literal: true

require 'test_helper'

class RobotsControllerTest < ActionDispatch::IntegrationTest
  test "should return a robots file" do
    get '/robots.txt'
    assert_response :success
  end
end

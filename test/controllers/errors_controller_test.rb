require 'test_helper'

class ErrorsControllerTest < ActionDispatch::IntegrationTest
  test "bad facet id should return not_found" do
    get '/catalog/facet/about'
    assert_response :not_found
  end

  test "should get not_found" do
    get '/404'
    assert_response :success
  end

  test "should get internal_server_error" do
    get '/500'
    assert_response :success
  end
end

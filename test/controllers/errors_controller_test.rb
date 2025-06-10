require 'test_helper'

class ErrorsControllerTest < ActionDispatch::IntegrationTest
  test "bad facet id should return not_found" do
    assert_raises(ActionController::RoutingError) do
      get '/catalog/facet/about'
    end
  end

  test "bad catalog id should return BL RecordNotFound" do
    assert_raises(Blacklight::Exceptions::RecordNotFound) do
      get '/catalog/foo-dog'
    end
  end

  test "bad catalog id should return BL RecordNotFound" do
    get '/catalog/foo-dog'
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

require 'test_helper'

class CatalogControllerTest < ActionDispatch::IntegrationTest
  test "should return admin view" do
    get '/catalog/b06d96e4-c917-4afc-a3df-adbbc9a2273c/admin'
    assert_response :success
  end
end

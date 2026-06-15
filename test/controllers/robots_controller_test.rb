require 'test_helper'

class RobotsControllerTest < ActionDispatch::IntegrationTest
  test "should disallow all crawlers" do
    get '/robots.txt'

    assert_response :success
    assert_includes response.body, "User-agent: *"
    assert_includes response.body, "Disallow: /"
    assert_not_includes response.body, "Crawl-delay:"
    assert_not_includes response.body, "Sitemap:"
  end
end

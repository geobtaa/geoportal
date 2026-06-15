require "test_helper"
require "net/http"
require "uri"

# Fetches the live robots.txt from geodev and asserts it disallows all crawlers.
# Fails until geodev is configured (e.g. DISALLOW_ALL_ROBOTS=true) to serve disallow-all.
class RobotsTest < ActionDispatch::IntegrationTest
  GEODEV_ROBOTS_URL = "https://geodev.btaa.org/robots.txt"

  test "geodev.btaa.org robots.txt disallows all crawlers" do
    uri = URI(GEODEV_ROBOTS_URL)
    response = Net::HTTP.get_response(uri)

    assert response.is_a?(Net::HTTPSuccess), "Expected 2xx from #{GEODEV_ROBOTS_URL}, got #{response.code} #{response.message}"
    body = response.body

    assert_includes body, "User-agent: *", "geodev robots.txt must include User-agent: *"
    assert_includes body, "Disallow: /", "geodev robots.txt must disallow all (Disallow: /)"
    assert_not_includes body, "Crawl-delay:", "geodev must not expose production crawl rules (Crawl-delay)"
    assert_not_includes body, "Disallow: /?q=", "geodev must not expose production disallow rules (e.g. /?q=)"
  end
end

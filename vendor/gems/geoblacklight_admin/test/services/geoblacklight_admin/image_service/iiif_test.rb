# frozen_string_literal: true

require "test_helper"

module GeoblacklightAdmin
  class ImageService::IiifTest < ActiveSupport::TestCase
    def setup
      @document = Minitest::Mock.new
      @document.expect :viewer_endpoint, "http://example.com/iiif/2/1234/info.json"
    end

    def test_image_url
      expected_url = "http://example.com/iiif/2/1234/full/max/0/default.jpg"
      assert_equal expected_url, GeoblacklightAdmin::ImageService::Iiif.image_url(@document, 100)
    end
  end
end

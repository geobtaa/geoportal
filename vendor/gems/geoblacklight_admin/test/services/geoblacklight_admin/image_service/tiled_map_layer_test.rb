# frozen_string_literal: true

require "test_helper"

module GeoblacklightAdmin
  class ImageService::TiledMapLayerTest < ActiveSupport::TestCase
    setup do
      # Create a mock SolrDocument with the required viewer_endpoint field
      @document = Minitest::Mock.new
      @document.expect(:viewer_endpoint, "http://example.com/tiled_map_layer")
    end

    test "should return correct image URL for ESRI Tiled Map Layer" do
      expected_url = "http://example.com/tiled_map_layer/info/thumbnail/thumbnail.png"

      actual_url = GeoblacklightAdmin::ImageService::TiledMapLayer.image_url(@document, 100)

      assert_equal expected_url, actual_url
    end

    teardown do
      # Verify that the expectations on the mock were met
      @document.verify
    end
  end
end

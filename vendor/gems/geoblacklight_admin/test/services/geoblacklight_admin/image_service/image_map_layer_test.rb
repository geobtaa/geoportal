# frozen_string_literal: true

require "test_helper"

module GeoblacklightAdmin
  class ImageService::ImageMapLayerTest < ActiveSupport::TestCase
    setup do
      # Create a mock SolrDocument with the required viewer_endpoint field
      @document = Minitest::Mock.new
      @document.expect(:viewer_endpoint, "http://example.com/image_map_layer")
    end

    test "should return correct image URL for ESRI Image Map Layer" do
      expected_url = "http://example.com/image_map_layer/info/thumbnail/thumbnail.png"

      actual_url = GeoblacklightAdmin::ImageService::ImageMapLayer.image_url(@document, 100)

      assert_equal expected_url, actual_url
    end

    teardown do
      # Verify that the expectations on the mock were met
      @document.verify
    end
  end
end

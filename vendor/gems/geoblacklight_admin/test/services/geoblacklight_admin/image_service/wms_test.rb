# frozen_string_literal: true

require "test_helper"

module GeoblacklightAdmin
  class ImageService::WmsTest < ActiveSupport::TestCase
    setup do
      # Create a mock SolrDocument with necessary fields
      @document = Minitest::Mock.new
      @document.expect(:viewer_endpoint, "http://example.com/wms")
      @document.expect(:[], "layer_id", ["gbl_wxsIdentifier_s"])
    end

    test "should generate correct WMS image URL with specified size" do
      size = 200
      expected_url = "http://example.com/wms/reflect?" \
                     "&FORMAT=image%2Fpng" \
                     "&TRANSPARENT=TRUE" \
                     "&LAYERS=layer_id" \
                     "&WIDTH=200" \
                     "&HEIGHT=200"

      actual_url = GeoblacklightAdmin::ImageService::Wms.image_url(@document, size)
      assert_equal expected_url, actual_url
    end

    test "should generate correct WMS image URL with different size" do
      size = 400
      expected_url = "http://example.com/wms/reflect?" \
                     "&FORMAT=image%2Fpng" \
                     "&TRANSPARENT=TRUE" \
                     "&LAYERS=layer_id" \
                     "&WIDTH=400" \
                     "&HEIGHT=400"

      actual_url = GeoblacklightAdmin::ImageService::Wms.image_url(@document, size)
      assert_equal expected_url, actual_url
    end

    teardown do
      # Verify that the expectations on the mock were met
      @document.verify
    end
  end
end

# frozen_string_literal: true

require "test_helper"
require "json"
require "down"

module GeoblacklightAdmin
  class ImageService::IiifManifestTest < ActiveSupport::TestCase
    setup do
      # Create a basic document object with the necessary method
      @document = Struct.new(:viewer_endpoint).new("https://example.com/manifest.json")
    end

    test "should return first image URL from sequences" do
      manifest_json = {
        "sequences" => [
          {
            "canvases" => [
              {
                "images" => [
                  {"resource" => {"@id" => "https://example.com/image1.jpg"}}
                ]
              }
            ]
          }
        ]
      }

      Down.stub :download, mock_tempfile(manifest_json) do
        actual_url = GeoblacklightAdmin::ImageService::IiifManifest.image_url(@document, 100)
        assert_equal "https://example.com/image1.jpg", actual_url
      end
    end

    test "should return first item body id from Northwestern's manifest" do
      manifest_json = {
        "items" => [
          {
            "items" => [
              {
                "items" => [
                  {"body" => {"id" => "https://example.com/northwestern_image.jpg"}}
                ]
              }
            ]
          }
        ]
      }

      Down.stub :download, mock_tempfile(manifest_json) do
        actual_url = GeoblacklightAdmin::ImageService::IiifManifest.image_url(@document, 100)
        assert_equal "https://example.com/northwestern_image.jpg", actual_url
      end
    end

    test "should return thumbnail URL if sequences and items are missing" do
      manifest_json = {
        "thumbnail" => {
          "@id" => "https://example.com/thumbnail.jpg"
        }
      }

      Down.stub :download, mock_tempfile(manifest_json) do
        actual_url = GeoblacklightAdmin::ImageService::IiifManifest.image_url(@document, 100)
        assert_equal "https://example.com/thumbnail.jpg", actual_url
      end
    end

    test "should return viewer endpoint if no valid image is found" do
      manifest_json = {} # Empty manifest

      Down.stub :download, mock_tempfile(manifest_json) do
        actual_url = GeoblacklightAdmin::ImageService::IiifManifest.image_url(@document, 100)
        assert_equal "https://example.com/manifest.json", actual_url
      end
    end

    test "should handle errors gracefully and return viewer endpoint" do
      Down.stub :download, proc { raise StandardError, "Download failed" } do
        actual_url = GeoblacklightAdmin::ImageService::IiifManifest.image_url(@document, 100)
        assert_equal "https://example.com/manifest.json", actual_url
      end
    end

    private

    # Helper method to mock a tempfile containing JSON data
    def mock_tempfile(json)
      tempfile = Tempfile.new
      tempfile.write(json.to_json)
      tempfile.rewind
      tempfile
    end
  end
end

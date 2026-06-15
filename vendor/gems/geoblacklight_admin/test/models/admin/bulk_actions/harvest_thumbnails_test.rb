require "test_helper"

module BulkActions
  class HarvestThumbnailsTest < ActiveSupport::TestCase
    test "should be a subclass of BulkAction" do
      assert HarvestThumbnails < BulkAction
    end
  end
end

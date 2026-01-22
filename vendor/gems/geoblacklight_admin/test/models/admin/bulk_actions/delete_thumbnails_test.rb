require "test_helper"

module BulkActions
  class DeleteThumbnailsTest < ActiveSupport::TestCase
    test "should be a subclass of BulkAction" do
      assert DeleteThumbnails < BulkAction
    end
  end
end

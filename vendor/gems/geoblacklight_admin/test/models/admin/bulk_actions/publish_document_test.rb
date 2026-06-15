require "test_helper"

module BulkActions
  class PublishDocumentTest < ActiveSupport::TestCase
    test "should be a subclass of BulkAction" do
      assert PublishDocument < BulkAction
    end
  end
end

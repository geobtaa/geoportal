require "test_helper"

module BulkActions
  class UnpublishDocumentTest < ActiveSupport::TestCase
    test "should be a subclass of BulkAction" do
      assert UnpublishDocument < BulkAction
    end
  end
end

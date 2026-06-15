require "test_helper"

class BulkActionCollectDocumentsTest < ActiveJob::TestCase
  test "perform method calls collect_documents on BulkAction" do
    bulk_action = bulk_actions(:one) # Assuming you have a fixture named :one

    # Stub the collect_documents method
    def bulk_action.collect_documents
      @collect_documents_called = true
    end

    # Track if the method was called
    bulk_action.instance_variable_set(:@collect_documents_called, false)

    BulkAction.stub :find, bulk_action do
      BulkActionCollectDocuments.perform_now(bulk_action.id)
    end

    assert bulk_action.instance_variable_get(:@collect_documents_called), "collect_documents was not called"
  end
end

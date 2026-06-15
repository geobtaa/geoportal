# frozen_string_literal: true

# BulkActionCollectDocuments class
class BulkActionCollectDocuments < ApplicationJob
  queue_as :priority

  def perform(bulk_action_id)
    bulk_action = BulkAction.find(bulk_action_id)
    bulk_action.collect_documents
  end
end

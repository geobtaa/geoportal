# frozen_string_literal: true

# BulkActionRevertJob
class BulkActionRevertJob < ApplicationJob
  queue_as :priority

  def perform(bulk_action)
    action = case bulk_action.field_name
    when "Publication State"
      logger.debug("BulkAction: Revert Publication Status")
      :revert_publication_status
    when "Delete"
      logger.debug("BulkAction: Revert Delete")
      :revert_delete
    else
      logger.debug("BulkAction: Revert Field Value")
      :revert_field_value
    end

    bulk_action.documents.each do |doc|
      BulkActionRevertDocumentJob.perform_later(action, doc)
      doc.state_machine.transition_to!(:queued)
    end
  end
end

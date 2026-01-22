# frozen_string_literal: true

# BulkActionRunJob
class BulkActionRunJob < ApplicationJob
  queue_as :priority

  after_perform do |job|
    logger.debug("BulkActionRunJob - After Perform - #{job.arguments.first.id}")
    job.arguments.first.state_machine.transition_to!(:complete)
  end

  def perform(bulk_action)
    action = case bulk_action.field_name
    when "Publication State"
      logger.debug("BulkAction: Update Publication Status")
      :update_publication_status
    when "Delete"
      logger.debug("BulkAction: Delete")
      :update_delete
    when "Harvest Thumbnails"
      logger.debug("BulkAction: Harvest Thumbnails")
      :harvest_thumbnails
    when "Delete Thumbnails"
      logger.debug("BulkAction: Delete Thumbnails")
      :delete_thumbnails
    else
      :update_field_value
    end

    bulk_action.documents.each do |doc|
      BulkActionRunDocumentJob.perform_later(action, doc, bulk_action.field_name, bulk_action.field_value)
    end

    # Capture State
    bulk_action.state_machine.transition_to!(:queued)
  end
end

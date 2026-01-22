# frozen_string_literal: true

##
# Module for GeoblacklightAdmin related jobs.
module GeoblacklightAdmin
  ##
  # A job to delete the thumbnail associated with a Solr document.
  #
  # This job is enqueued with a priority queue and can optionally handle
  # a bad document ID to transition its state.
  class DeleteThumbnailJob < ApplicationJob
    ##
    # Determines the queue to use based on the last argument.
    queue_as do
      arguments.last
    end

    ##
    # Performs the job to delete a thumbnail.
    #
    # @param solr_document_id [String] the ID of the Solr document
    # @param bad_id [String, nil] optional ID of a bad document to transition
    # @param queue [Symbol] the queue to use, defaults to :priority
    #
    # If the document has a thumbnail, it will be destroyed.
    # If a bad_id is provided, it will transition the state of the
    # BulkActionDocument to :success.
    def perform(solr_document_id, bad_id = nil, queue = :priority)
      document = Document.find_by_friendlier_id(solr_document_id)
      if document.thumbnail.present?
        document.thumbnail.destroy!
      end
      BulkActionDocument.find(bad_id).state_machine.transition_to!(:success) if bad_id.present?
    end
  end
end

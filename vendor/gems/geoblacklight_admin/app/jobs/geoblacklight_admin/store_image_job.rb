# frozen_string_literal: true

##
# Module for GeoblacklightAdmin jobs.
module GeoblacklightAdmin
  ##
  # StoreImageJob is responsible for handling the storage of images
  # associated with a Solr document. It manages the lifecycle of the
  # image storage process, including state transitions and error handling.
  class StoreImageJob < ApplicationJob
    ##
    # Sets the queue for the job based on the last argument provided.
    queue_as do
      arguments.last
    end

    ##
    # Performs the job to store an image for a given Solr document.
    #
    # @param solr_document_id [String] the ID of the Solr document
    # @param bad_id [String, nil] optional ID for a BulkActionDocument
    # @param queue [Symbol] the queue to use for the job, defaults to :default
    #
    # This method:
    # - Finds the document by its friendlier ID.
    # - Deletes any existing thumbnail.
    # - Transitions the document's thumbnail state to 'queued'.
    # - Waits for a random period to ensure polite crawling.
    # - Stores the image using the ImageService.
    # - Transitions the BulkActionDocument state to 'success' if a bad_id is provided.
    def perform(solr_document_id, bad_id = nil, queue = :default)
      # Find the document
      document = Document.find_by_friendlier_id(solr_document_id)

      # Delete thumbnail if already present
      if document&.thumbnail&.present?
        document.thumbnail.destroy!
      end

      # Statesman
      metadata = {}
      metadata["solr_doc_id"] = solr_document_id
      document.thumbnail_state_machine.transition_to!(:queued, metadata)

      # Crawl politely
      sleep(rand(1..5))

      # Store the image
      GeoblacklightAdmin::ImageService.new(document).store
      BulkActionDocument.find(bad_id).state_machine.transition_to!(:success) if bad_id.present?
    end
  end
end

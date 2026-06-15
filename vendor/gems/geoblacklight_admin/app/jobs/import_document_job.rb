# frozen_string_literal: true

# ImportDocumentJob class
class ImportDocumentJob < ApplicationJob
  queue_as :priority

  def perform(import_document)
    document = Document.find_or_create_by(friendlier_id: import_document.friendlier_id)

    # Set the geom
    document.set_geometry

    # Update document with import data
    document_data = import_document.to_hash
    publication_state = document_data[:json_attributes]["b1g_publication_state_s"]
    document_data[:json_attributes].delete("b1g_publication_state_s")
    document_data.delete(:publication_state)

    if document.update(document_data)
      # Handle state transition separately
      if publication_state.present?
        document.publication_state = publication_state
        document.save
      end
      import_document.state_machine.transition_to!(:success)
    else
      import_document.state_machine.transition_to!(:failed, "Failed - #{document.errors.inspect}")
    end
  rescue => e
    logger.debug("Error: #{e}")
    import_document.state_machine.transition_to!(:failed, "Error - #{e.inspect}")
  end
end

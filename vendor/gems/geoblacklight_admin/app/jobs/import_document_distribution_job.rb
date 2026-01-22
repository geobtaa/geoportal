# frozen_string_literal: true

# ImportDocumentDistributionJob class
class ImportDocumentDistributionJob < ApplicationJob
  queue_as :priority

  def perform(import_document_distribution)
    document_distribution = DocumentDistribution.find_or_create_by(
      friendlier_id: import_document_distribution.friendlier_id,
      reference_type: ReferenceType.find_by(name: import_document_distribution.reference_type),
      url: import_document_distribution.distribution_url
    )

    if document_distribution.update(import_document_distribution.to_hash)
      import_document_distribution.state_machine.transition_to!(:success)
    else
      import_document_distribution.state_machine.transition_to!(:failed, "Failed - #{document_distribution.errors.inspect}")
    end
  rescue => e
    logger.debug("Error: #{e}")
    import_document_distribution.state_machine.transition_to!(:failed, "Error - #{e.inspect}")
  end
end

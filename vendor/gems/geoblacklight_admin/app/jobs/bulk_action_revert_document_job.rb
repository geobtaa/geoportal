# frozen_string_literal: true

# BulkActionRevertDocumentJob
class BulkActionRevertDocumentJob < ApplicationJob
  queue_as :priority

  def perform(action, doc)
    case action
    when :revert_publication_status
      revert_publication_status(doc)
    when :revert_delete
      revert_delete(doc)
    else
      logger.debug("@TODO - #{field_name} => #{field_value}")
    end
  end

  def revert_publication_status(doc)
    document = Document.find_by!(friendlier_id: doc.friendlier_id)

    logger.debug("Revert PubStatus - #{document.friendlier_id}")

    versions = document.versions
    document = versions[doc.current_version].reify
    document&.skip_callbacks = true

    document.save
  end

  def revert_delete(doc)
    document = Document.find_by!(friendlier_id: doc.friendlier_id)

    logger.debug("Revert Delete - #{document.id}")

    versions = document.versions
    document = versions.last.reify
    document.skip_callbacks = true

    document.save
  end
end

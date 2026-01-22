# frozen_string_literal: true

# BulkActionRunDocumentJob
class BulkActionRunDocumentJob < ApplicationJob
  queue_as :priority

  def perform(action, doc, field_name, field_value)
    case action
    when :update_publication_status
      update_publication_status(doc, field_value)
    when :update_delete
      update_delete(doc, field_value)
    when :harvest_thumbnails
      GeoblacklightAdmin::StoreImageJob.perform_later(doc.friendlier_id, doc.id, :priority)
    when :delete_thumbnails
      GeoblacklightAdmin::DeleteThumbnailJob.perform_later(doc.friendlier_id, doc.id, :priority)
    else
      # @TODO: Field Level changes
      logger.debug("@TODO - #{field_name} => #{field_value}")
    end
  end

  def update_publication_status(doc, field_value)
    document = Document.find_by!(friendlier_id: doc.friendlier_id)

    # Map field value to publication state
    pub_state = case field_value
    when "publish"
      "published"
    when "unpublish"
      "unpublished"
    when "set as draft"
      "draft"
    end

    logger.debug("Update PubStatus - #{document.friendlier_id} - #{pub_state} - #{field_value}")

    document.update!(publication_state: pub_state)
  end

  def update_delete(doc, field_value)
    document = Document.find_by!(friendlier_id: doc.friendlier_id)

    logger.debug("Update Delete - #{document.friendlier_id} => #{field_value}")

    document.destroy
  end
end

# frozen_string_literal: true

# Change-capture for the `kithe_to_resources_bridge` materialized view.
#
# The bridge view uses the parent Document's `date_modified_dtsi` (stored in
# Document.json_attributes) as a "last updated" marker.
#
# Some related tables (data dictionaries + entries, downloads) don't update
# the parent Document record themselves. We hook into their callbacks so that
# changes are reflected in the parent and therefore captured when the MV is
# refreshed. We also record hard-deleted Documents into a tombstone table so
# incremental bridge syncs can see deletions after the next MV refresh.
module KitheBridgeChangeCapture
  module_function

  def touch_parent_document!(document)
    return if document.nil?

    now = Time.current.utc
    json = document.json_attributes.is_a?(Hash) ? document.json_attributes : {}

    # Restore the previous behavior: set date_modified_dtsi explicitly.
    # The bridge sync can now focus on kithe_updated_at, but keeping the
    # legacy timestamp field up to date preserves existing semantics.
    json["date_modified_dtsi"] = now.iso8601

    document.update_columns(
      json_attributes: json,
      updated_at: now
    )
  end

  def capture_document_deletion!(document)
    return if document.nil? || document.friendlier_id.blank?
    return unless defined?(KitheBridgeDeletion)

    now = Time.current.utc
    json = document.json_attributes.is_a?(Hash) ? document.json_attributes : {}

    KitheBridgeDeletion.upsert(
      {
        friendlier_id: document.friendlier_id,
        kithe_model_id: document.id,
        title: document.title,
        import_id: document.import_id,
        publication_state: document.publication_state,
        geomg_id_s: json["geomg_id_s"],
        deleted_at: now,
        created_at: now,
        updated_at: now
      },
      unique_by: :index_kithe_bridge_deletions_on_friendlier_id
    )
  end
end

if defined?(Document)
  Document.class_eval do
    after_commit :kithe_bridge_capture_document_deletion, on: :destroy

    private

    def kithe_bridge_capture_document_deletion
      KitheBridgeChangeCapture.capture_document_deletion!(self)
    end
  end
end

if defined?(DocumentDataDictionary)
  DocumentDataDictionary.class_eval do
    after_save :kithe_bridge_touch_parent_document
    after_destroy :kithe_bridge_touch_parent_document

    private

    def kithe_bridge_touch_parent_document
      KitheBridgeChangeCapture.touch_parent_document!(document)
    end
  end
end

if defined?(DocumentDataDictionaryEntry)
  DocumentDataDictionaryEntry.class_eval do
    after_save :kithe_bridge_touch_parent_document
    after_destroy :kithe_bridge_touch_parent_document

    private

    def kithe_bridge_touch_parent_document
      KitheBridgeChangeCapture.touch_parent_document!(document_data_dictionary&.document)
    end
  end
end

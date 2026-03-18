# frozen_string_literal: true

# Change-capture for the `kithe_to_resources_bridge` materialized view.
#
# The bridge view uses the parent Document's `date_modified_dtsi` (stored in
# Document.json_attributes) as a "last updated" marker.
#
# Some related tables (data dictionaries + entries, downloads) don't update
# the parent Document record themselves. We hook into their callbacks so that
# changes are reflected in the parent and therefore captured when the MV is
# refreshed.
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


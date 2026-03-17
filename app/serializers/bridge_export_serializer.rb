class BridgeExportSerializer
  def initialize(bridge_row)
    @bridge_row = bridge_row
  end

  def as_json(*)
    # Start with all columns from the materialized view row
    result = bridge_row.attributes.dup

    friendlier_id = bridge_row.id
    document = Document.find_by(friendlier_id: friendlier_id)

    document_payload =
      if document
        DocumentExportSerializer.new(document).as_json
      else
        {}
      end

    # Always expose relational collections with their full table-based names,
    # even if they are empty.
    result["document_data_dictionaries"] =
      document_payload["data_dictionaries"] || document_payload[:data_dictionaries] || []

    result["document_data_dictionary_entries"] =
      document_payload["data_dictionary_entries"] || document_payload[:data_dictionary_entries] || []

    result["document_distributions"] =
      document_payload["distributions"] || document_payload[:distributions] || []

    result["document_downloads"] =
      document_payload["downloads"] || document_payload[:downloads] || []

    result["document_licensed_accesses"] =
      document_payload["licensed_accesses"] || document_payload[:licensed_accesses] || []

    result["assets"] = document_payload["assets"] || document_payload[:assets] || []

    result
  end

  private

  attr_reader :bridge_row
end


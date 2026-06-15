class DocumentExportSerializer
  def initialize(document)
    @document = document
  end

  def as_json(*)
    {
      document: serialize_document,
      data_dictionaries: serialize_data_dictionaries,
      data_dictionary_entries: serialize_data_dictionary_entries,
      distributions: serialize_distributions,
      downloads: serialize_downloads,
      licensed_accesses: serialize_licensed_accesses,
      assets: serialize_assets
    }
  end

  private

  attr_reader :document

  def serialize_document
    document.attributes.slice(
      "id",
      "friendlier_id",
      "title",
      "publication_state",
      "created_at",
      "updated_at",
      "import_id"
    )
  end

  def serialize_data_dictionaries
    document.document_data_dictionaries.map do |ddd|
      ddd.attributes.slice(
        "id",
        "friendlier_id",
        "name",
        "created_at",
        "updated_at"
      )
    end
  end

  def serialize_data_dictionary_entries
    DocumentDataDictionaryEntry
      .where(document_data_dictionary_id: document.document_data_dictionaries.select(:id))
      .order(:position)
      .map do |entry|
        # Table schema uses `values` (not `field_value`)
        entry.attributes.slice(
          "id",
          "document_data_dictionary_id",
          "friendlier_id",
          "field_name",
          "field_type",
          "values",
          "definition",
          "definition_source",
          "parent_field_name",
          "position",
          "created_at",
          "updated_at"
        )
      end
  end

  def serialize_distributions
    DocumentDistribution
      .where(friendlier_id: document.friendlier_id)
      .map do |dist|
        dist.attributes.slice(
          "id",
          "friendlier_id",
          "reference_type_id",
          "url",
          "label",
          "created_at",
          "updated_at"
        )
      end
  end

  def serialize_downloads
    if defined?(DocumentDownload)
      DocumentDownload
        .where(friendlier_id: document.friendlier_id)
        .map do |download|
          {
            "id" => download.id,
            "friendlier_id" => download.friendlier_id,
            "label" => download.label,
            "value" => download.value,
            # Backwards-friendly alias for downstream expectations.
            "url" => download.value,
            "position" => download.position,
            "created_at" => download.created_at,
            "updated_at" => download.updated_at
          }
        end
    else
      []
    end
  end

  def serialize_licensed_accesses
    document.document_licensed_accesses.map do |dla|
      dla.attributes.slice(
        "id",
        "friendlier_id",
        "institution_code",
        "access_url",
        "created_at",
        "updated_at"
      )
    end
  end

  def serialize_assets
    document.document_assets.map do |asset|
      AssetExportSerializer.new(asset).as_json
    end
  end
end


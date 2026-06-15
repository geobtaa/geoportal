class AssetExportSerializer
  def initialize(asset)
    @asset = asset
  end

  def as_json(*)
    {
      id: asset.id,
      friendlier_id: asset.friendlier_id,
      parent_id: asset.parent_id,
      parent_friendlier_id: asset.parent&.friendlier_id,
      title: asset.title,
      label: asset.label,
      thumbnail: asset.thumbnail,
      dct_references_uri_key: asset.dct_references_uri_key,
      position: asset.position,
      created_at: asset.created_at,
      updated_at: asset.updated_at,
      file: serialize_file,
      derivatives: serialize_derivatives
    }
  end

  private

  attr_reader :asset

  def serialize_file
    return nil unless asset.file_data

    {
      storage: asset.file_data["storage"],
      id: asset.file_data["id"],
      metadata: asset.file_data["metadata"],
      url: asset.full_file_url
    }
  end

  def serialize_derivatives
    []
  end
end


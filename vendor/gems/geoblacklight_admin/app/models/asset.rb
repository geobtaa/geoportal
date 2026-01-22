class Asset < Kithe::Asset
  belongs_to :parent, class_name: "Document", optional: true

  include AttrJson::Record::QueryScopes
  include Rails.application.routes.url_helpers

  # Default Sort Order
  default_scope { order(parent_id: :desc, created_at: :asc) }

  set_shrine_uploader(AssetUploader)

  # AttrJSON
  attr_json :thumbnail, :boolean, default: "false"
  attr_json :derivative_storage_type, :string, default: "public"
  attr_json :dct_references_uri_key, :string
  attr_json :label, :string

  DERIVATIVE_STORAGE_TYPE_LOCATIONS = {
    "public" => :kithe_derivatives
  }.freeze

  scope :to_aardvark_references, -> { where(parent_id: pluck(:parent_id)).map(&:to_aardvark_reference) }

  def full_file_url
    if Rails.env.development?
      "http://localhost:3000" + file.url
    else
      file.url
    end
  end

  # After Promotion Callbacks
  after_promotion :set_parent_dct_references_uri

  def set_parent_dct_references_uri
    GeoblacklightAdmin::SetParentDctReferencesUriJob.perform_later(self) if parent_id.present?
  end

  # Before Destroy Callbacks
  before_destroy :remove_parent_dct_references_uri

  def remove_parent_dct_references_uri
    GeoblacklightAdmin::RemoveParentDctReferencesUriJob.perform_later(self) if parent_id.present?
  end

  # After Commit Callbacks
  after_commit :reindex_parent

  def reindex_parent
    # Set the "file size" on the parent document
    file_size = 0
    if parent.present? && !parent.destroyed?
      unless thumbnail?
        parent.document_assets.each do |document_asset|
          file_size += document_asset.file_data["metadata"]["size"]
        end
        parent.gbl_fileSize_s = ApplicationController.helpers.number_to_human_size(file_size)
        parent.save(validate: false)
      end
    end
  end

  def to_aardvark_reference
    hash = {}
    if dct_references_uri_key.present?
      reference_type = ReferenceType.find_by_name(dct_references_uri_key)
      hash[reference_type.reference_uri.to_s] = if reference_type.reference_uri.to_s == "http://schema.org/downloadUrl"
        logger.debug("Asset#to_aardvark_reference > downloadUrl: #{full_file_url} > #{label.present? ? label : file.metadata["filename"]}")

        {
          "url" => full_file_url,
          "label" => label.present? ? label : file.metadata["filename"]
        }
      else
        full_file_url
      end
    end
    hash
  end
end

# Allow DocumentAsset to be used as a synonym for Asset
DocumentAsset = Asset

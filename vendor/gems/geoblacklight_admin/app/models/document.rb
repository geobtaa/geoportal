# frozen_string_literal: true

# Document
class Document < Kithe::Work
  include AttrJson::Record::QueryScopes
  include ActiveModel::Validations

  delegate :viewer_protocol, to: :item_viewer
  delegate :viewer_endpoint, to: :item_viewer

  def item_viewer
    GeoblacklightAdmin::ItemViewer.new(distributions)
  end

  attr_accessor :skip_callbacks

  has_paper_trail ignore: [:publication_state]
  belongs_to :import, optional: true

  # Statesman
  # - Publication State
  has_many :document_transitions, foreign_key: "kithe_model_id", autosave: false, dependent: :destroy,
    inverse_of: :document

  # - Thumbnail State
  has_many :document_thumbnail_transitions, foreign_key: "kithe_model_id", autosave: false, dependent: :destroy,
    inverse_of: :document

  # Document Collections
  # - DocumentLicensedAccesses
  has_many :document_licensed_accesses, primary_key: "friendlier_id", foreign_key: "friendlier_id", autosave: false, dependent: :destroy,
    inverse_of: :document

  # - DocumentDataDictionaries
  has_many :document_data_dictionaries, primary_key: "friendlier_id", foreign_key: "friendlier_id", autosave: false, dependent: :destroy,
    inverse_of: :document

  # - DocumentDistributions
  has_many :document_distributions, primary_key: "friendlier_id", foreign_key: "friendlier_id", autosave: false, dependent: :destroy,
    inverse_of: :document

  # DocumentAssets - Thumbnails, Attachments, etc
  # @TODO: Redundant? Kithe also includes a members association
  def document_assets
    scope = Kithe::Asset
    scope = scope.where(parent_id: id).order(position: :asc)
    scope.includes(:parent)
  end

  def distributable_assets
    document_assets.select { |a| a.dct_references_uri_key.present? }
  end

  include Statesman::Adapters::ActiveRecordQueries[
    transition_class: DocumentTransition,
    initial_state: :draft
  ]

  # @TODO: Rename this to publication_state_machine
  def state_machine
    @state_machine ||= DocumentStateMachine.new(self, transition_class: DocumentTransition)
  end

  include Statesman::Adapters::ActiveRecordQueries[
    transition_class: DocumentThumbnailTransition,
    initial_state: :initialized
  ]

  def thumbnail_state_machine
    @thumbnail_state_machine ||= DocumentThumbnailStateMachine.new(self, transition_class: DocumentThumbnailTransition)
  end

  def raw_solr_document
    Blacklight.default_index.connection.get("select", {params: {q: "id:\"#{geomg_id_s}\""}})["response"]["docs"][0]
  end

  delegate :current_state, to: :state_machine

  before_save :transition_publication_state, unless: :skip_callbacks
  before_save :set_geometry

  # Indexer
  self.kithe_indexable_mapper = DocumentIndexer.new

  # Validations
  validates :title, :dct_accessRights_s, :gbl_resourceClass_sm, :geomg_id_s, presence: true

  # Test for collection and restricted
  validates :dct_format_s, presence: true, if: :a_downloadable_resource?

  # Downloadable Resouce
  def a_downloadable_resource?
    json_attributes["dct_references_s"]&.any? { |ref| ref.category == "download" }
  end

  validates_with Document::DateValidator
  validates_with Document::DateRangeValidator
  validates_with Document::BboxValidator
  validates_with Document::GeomValidator

  # Definte our AttrJSON attributes
  if ActiveRecord::Base.connection.table_exists?("elements")
    Element.all.each do |attribute|
      next if attribute.solr_field == "dct_references_s"

      if attribute.repeatable?
        attr_json attribute.solr_field.to_sym, attribute.field_type.to_sym, array: true, default: -> { [] }
      else
        attr_json attribute.solr_field.to_sym, attribute.field_type.to_sym, default: ""
      end
    end
  end

  attr_json :dct_references_s, Document::Reference.to_type, array: true, default: -> { [] }

  # Distributions
  def distributions
    # Add DocumentDistributions to distributions
    distributions = document_distributions.to_aardvark_distributions
    logger.debug("Document#distributions > document_distributions: #{distributions}")

    # Apply Distributable Assets
    distributions = apply_assets(distributions)
    logger.debug("Document#distributions > assets: #{distributions}")

    # Flatten the arrays here to avoid the following potential error:
    # - ArgumentError: Please use symbols for polymorphic route arguments.
    # - Via: app/helpers/geoblacklight_helper.rb:224:in `render_references_url'
    distributions.each do |key, value|
      next if key == "http://schema.org/downloadUrl"
      if value.is_a?(Array) && value.length == 1
        distributions[key] = value.first
      end
    end

    distributions
  end

  # Distributions JSON
  # - Indexes to Solr as dct_distributions_s
  def distributions_json
    logger.debug("Document#distributions_json > using document_distributions")
    distributions = document_distributions.to_aardvark_distributions
    distributions = apply_assets(distributions)
    distributions.to_json
  end

  def distributions_csv
    # Initialize CSV
    # - [document_id, category, value, label]
    csv = []

    distributions.each do |key, value|
      if key == "http://schema.org/downloadUrl" || key == :"http://schema.org/downloadUrl"
        value.each do |download|
          logger.debug("Document#distributions_csv > download: #{download.inspect}")

          csv << [
            friendlier_id,
            ReferenceType.find_by(reference_uri: key).name,
            download["url"],
            download["label"]
          ]
        end
      else
        csv << [
          friendlier_id,
          ReferenceType.find_by(reference_uri: key)&.name,
          value,
          nil
        ]
      end
    end
    csv
  end

  def asset_label(asset)
    if asset.label.present?
      asset.label
    else
      asset.title
    end
  end

  def apply_assets(distributions)
    # Distributable Document Assets
    # - Via DocumentAssets (Assets)
    # - With Downloadable URI
    if distributable_assets.present?
      distributable_assets.each do |asset|
        if asset.dct_references_uri_key == "download"
          distributions["http://schema.org/downloadUrl"] ||= []
          distributions["http://schema.org/downloadUrl"] << asset.to_aardvark_reference["http://schema.org/downloadUrl"]
        else
          distributions.merge!(asset.to_aardvark_reference)
        end
      end
    end

    distributions
  end

  ### From GBL
  ##
  # Looks up properly formatted names for formats
  #
  def proper_case_format(format)
    if I18n.exists?("geoblacklight.formats.#{format.to_s.parameterize(separator: "_")}")
      I18n.t("geoblacklight.formats.#{format.to_s.parameterize(separator: "_")}")
    else
      format
    end
  end

  ##
  # Wraps download text with proper_case_format
  #
  def download_text(format)
    download_format = proper_case_format(format)
    download_format.to_s.html_safe
  rescue
    format.to_s.html_safe
  end

  ##
  # GBL SolrDocument convience methods
  #
  def available?
    public? || same_institution?
  end

  def public?
    rights_field_data.present? && rights_field_data.casecmp("public").zero?
  end

  def local_restricted?
    local? && restricted?
  end

  def local?
    local = send(Settings.FIELDS.PROVIDER) || ""
    local.casecmp(Settings.INSTITUTION)&.zero?
  end

  def restricted?
    rights_field_data.blank? || rights_field_data.casecmp("restricted").zero?
  end

  def rights_field_data
    send(Settings.FIELDS.ACCESS_RIGHTS) || ""
  end

  def downloadable?
    (direct_download || download_types.present? || iiif_download) && available?
  end

  def direct_download
    distributions.download.to_hash if distributions.download.present?
  end

  def display_note
    send(Settings.FIELDS.DISPLAY_NOTE) || ""
  end

  def hgl_download
    distributions.hgl.to_hash if distributions.hgl.present?
  end

  def oembed
    distributions.oembed.endpoint if distributions.oembed.present?
  end

  def same_institution?
    institution = send(Settings.FIELDS.PROVIDER) || ""
    institution.casecmp(Settings.INSTITUTION.downcase).zero?
  end

  def iiif_download
    distributions.iiif.to_hash if distributions.iiif.present?
  end

  def data_dictionary_download
    distributions.data_dictionary.to_hash if distributions.data_dictionary.present?
  end

  def external_url
    distributions.url&.endpoint
  end

  def itemtype
    "http://schema.org/Dataset"
  end

  def geom_field
    send(Settings.FIELDS.GEOMETRY) || ""
  end

  def geometry
    # @TODO
    # @geometry ||= Geoblacklight::Geometry.new(geom_field)
  end

  def wxs_identifier
    send(Settings.FIELDS.WXS_IDENTIFIER) || ""
  end

  def file_format
    send(Settings.FIELDS.FORMAT) || ""
  end

  ##
  # Provides a convenience method to access a SolrDocument's References
  # endpoint url without having to check and see if it is available
  # :type => a string which if its a Geoblacklight::Constants::URI key
  #          will return a coresponding Geoblacklight::Reference
  def checked_endpoint(type)
    type = distributions.send(type)
    type.endpoint if type.present?
  end

  ### End / From GBL

  # Thumbnail is a special case of document_assets
  def thumbnail
    members.find { |m| m.respond_to?(:thumbnail) && m.thumbnail? }
  end

  def access_json
    access = {}
    access_urls.each { |au| access[au.institution_code] = au.access_url }
    access.to_json
  end

  def created_at_dt
    created_at&.utc&.iso8601
  end

  def gbl_mdModified_dt
    updated_at&.utc&.iso8601
  end

  # Ensures a manually created "title" makes it into the attr_json "title"
  def dct_title_s
    title
  end

  def date_range_json
    date_ranges = []
    unless send(GeoblacklightAdmin::Schema.instance.solr_fields[:date_range]).all?(&:blank?)
      send(GeoblacklightAdmin::Schema.instance.solr_fields[:date_range]).each do |date_range|
        start_d, end_d = date_range.split("-")
        start_d = "*" if start_d == "YYYY" || start_d.nil?
        end_d = "*" if end_d == "YYYY" || end_d.nil?
        date_ranges << "[#{start_d} TO #{end_d}]" if start_d.present?
      end
    end
    date_ranges
  end

  def solr_year_json
    return [] if send(GeoblacklightAdmin::Schema.instance.solr_fields[:date_range]).blank?

    start_d, _end_d = send(GeoblacklightAdmin::Schema.instance.solr_fields[:date_range]).first.split("-")
    [start_d] if start_d.presence
  end
  alias_method :gbl_indexYear_im, :solr_year_json

  # Export Transformations - to_*
  def to_csv
    attributes = GeoblacklightAdmin::Schema.instance.exportable_fields
    attributes.map do |key, value|
      if value[:delimited]
        send(value[:destination])&.join("|")
      elsif value[:destination] == "dct_references_s"
        # @TODO: Downloads need to be handled differently
        # - Need to support multiple entries per key here
        # - Need to respect label and url
        dct_references_s_to_csv(key, value[:destination])
      elsif value[:destination] == "b1g_publication_state_s"
        send(:current_state)
      else
        next if send(value[:destination]).blank?
        send(value[:destination])
      end
    end
  end

  def to_traject
    Kithe::Model.find_by_friendlier_id(friendlier_id).update_index(writer: Traject::DebugWriter.new({}))
  end

  def dct_references_s_to_csv(key, destination)
    send(destination).detect do |ref|
      ref.category == GeoblacklightAdmin::Schema.instance.dct_references_mappings[key]
    end.value
  rescue NoMethodError
    nil
  end

  def current_version
    # Will return 0 if no PaperTrail version exists yet
    versions&.last&.index || 0
  end

  # Institutional Access URLs
  def access_urls
    DocumentLicensedAccess.where(friendlier_id: friendlier_id).order(institution_code: :asc)
  end

  def derive_locn_geometry
    if send(GeoblacklightAdmin::Schema.instance.solr_fields[:geometry]).present?
      send(GeoblacklightAdmin::Schema.instance.solr_fields[:geometry])
    elsif send(GeoblacklightAdmin::Schema.instance.solr_fields[:bounding_box]).present?
      derive_polygon
    else
      ""
    end
  end

  # Convert BBOX to GEOM Polygon
  def derive_polygon
    if send(GeoblacklightAdmin::Schema.instance.solr_fields[:bounding_box]).present?
      # Guard against a whole world polygons
      if send(GeoblacklightAdmin::Schema.instance.solr_fields[:bounding_box]) == "-180,-90,180,90"
        "ENVELOPE(-180,180,90,-90)"
      else
        # "W,S,E,N" convert to "POLYGON((W N, E N, E S, W S, W N))"
        w, s, e, n = send(GeoblacklightAdmin::Schema.instance.solr_fields[:bounding_box]).split(",")
        "POLYGON((#{w} #{n}, #{e} #{n}, #{e} #{s}, #{w} #{s}, #{w} #{n}))"
      end
    else
      ""
    end
  end

  def set_geometry
    return unless locn_geometry.blank? && self&.dcat_bbox&.present?

    self.locn_geometry = derive_polygon
  end

  # Convert GEOM for Solr Indexing
  def derive_dcat_bbox
    if send(GeoblacklightAdmin::Schema.instance.solr_fields[:bounding_box]).present?
      # "W,S,E,N" convert to "ENVELOPE(W,E,N,S)"
      w, s, e, n = send(GeoblacklightAdmin::Schema.instance.solr_fields[:bounding_box]).split(",")
      "ENVELOPE(#{w},#{e},#{n},#{s})"
    else
      ""
    end
  end

  def derive_dcat_centroid
    if send(GeoblacklightAdmin::Schema.instance.solr_fields[:bounding_box]).present?
      w, s, e, n = send(GeoblacklightAdmin::Schema.instance.solr_fields[:bounding_box]).split(",")
      "#{(n.to_f + s.to_f) / 2},#{(e.to_f + w.to_f) / 2}"
    else
      ""
    end
  end

  # Convert three char language code to proper string
  def iso_language_mapping
    mapping = []

    if send(GeoblacklightAdmin::Schema.instance.solr_fields[:language]).present?
      send(GeoblacklightAdmin::Schema.instance.solr_fields[:language]).each do |lang|
        mapping << GeoblacklightAdmin::IsoLanguageCodes.call[lang]
      end
    end
    mapping
  end

  private

  def transition_publication_state
    logger.debug("Document#transition_publication_state > publication_state: #{publication_state}")
    logger.debug("Document#transition_publication_state > b1g_publication_state_s: #{b1g_publication_state_s}")

    if publication_state_changed?
      state_machine.transition_to!(publication_state.downcase)
    elsif b1g_publication_state_s_changed?
      state_machine.transition_to!(b1g_publication_state_s.downcase)
    end
  end
end

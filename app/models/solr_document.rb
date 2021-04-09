# -*- encoding : utf-8 -*-
class SolrDocument

  include Blacklight::Solr::Document
  include Geoblacklight::SolrDocument
  include WmsRewriteConcern
  include B1gLicensedDataConcern

  # self.unique_key = 'id'
  self.unique_key = 'geomg_id_s'

  # Email uses the semantic field mappings below to generate the body of an email.
  SolrDocument.use_extension( Blacklight::Document::Email )

  # SMS uses the semantic field mappings below to generate the body of an SMS email.
  SolrDocument.use_extension( Blacklight::Document::Sms )

  # DublinCore uses the semantic field mappings below to assemble an OAI-compliant Dublin Core document
  # Semantic mappings of solr stored fields. Fields may be multi or
  # single valued. See Blacklight::Document::SemanticFields#field_semantics
  # and Blacklight::Document::SemanticFields#to_semantic_values
  # Recommendation: Use field names from Dublin Core
  use_extension( Blacklight::Document::DublinCore)

  # @TODO: flush out proper DC record
  self.field_semantics.merge!(
    :creator => "dct_creator_sm",
    :description => "dct_description_sm",
    :format => "dct_format_s",
    :identifier => "dct_identifier_sm",
    :language => "dct_language_sm",

    # @TODO: multiple publisher fields
    #:publisher => "dc_publisher_s",
    :publisher => "dct_publisher_sm",
    :relation => "dct_relation_sm",
    :rights => "dct_accessRights_s",
    :source => "dct_source_sm",
    :subject => "dct_subject_sm",
    :title => "dct_title_s",
    :type => "gbl_resourceClass_sm",

    # @TODO: multiple relation fields
    #:relation => "dct_isPartOf_sm",

    :coverage => "dct_spatial_sm",
    :date => "dct_temporal_sm",

    # @TODO: contributor or provenance?
    # @TODO: provenance isn't supported out of the box by BL
    :contributor => "schema_provider_s"
  )

  def sidecar
    # Find or create, and set version
    sidecar = SolrDocumentSidecar.where(
      document_id: id,
      document_type: self.class.to_s
    ).first_or_create do |sc|
      sc.version = self._source["_version_"]
    end

    # Set version - if doc has changed we'll reimage, someday
    sidecar.version = self._source["_version_"]
    sidecar.save

    sidecar
  end

  def uris
    uris = Array.new

    self.references.refs.each do |ref|
      uri = SolrDocumentUri.where(
        document_id: id,
        document_type: self.class.to_s,
        uri_key: ref.reference[0],
        uri_value: ref.reference[1]
      ).first_or_create do |sc|
        sc.version = self._source["_version_"]
      end

      uris << uri
    end

    return uris
  end

  def b1g_image
    self._source["b1g_image_ss"]
  end
end

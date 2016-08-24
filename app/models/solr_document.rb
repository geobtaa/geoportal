# -*- encoding : utf-8 -*-
class SolrDocument

  include Blacklight::Solr::Document
  include Geoblacklight::SolrDocument

  # self.unique_key = 'id'
  self.unique_key = 'layer_slug_s'

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
    :title => "dc_title_s",
    :author => "dc_creator_sm",
    :format => "dc_format_s"
  )

end

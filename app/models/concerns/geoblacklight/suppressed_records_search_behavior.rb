# frozen_string_literal: true
module Geoblacklight
  module SuppressedRecordsSearchBehavior
    extend ActiveSupport::Concern

    included do
      self.default_processor_chain += [:hide_suppressed_records]
    end

    ##
    # Hide suppressed records in search
    # @param [Blacklight::Solr::Request]
    # @return [Blacklight::Solr::Request]
    def hide_suppressed_records(solr_params)
      # Show suppressed child record actions if action is whitelisted here
      return if ['citation', 'web_services', 'metadata']. include?(blacklight_params.fetch(:action))

      # Show suppressed child records if searching for a specific source parent
      Settings.RELATIONSHIPS_SHOWN.map{ |_key,value| value.field }.uniq.each do |field|
        return unless blacklight_params.fetch(:f, {})[field.to_sym].nil?
      end

      # Do not suppress action_documents method calls for individual documents
      # ex. CatalogController#web_services (exportable views)
      return if solr_params[:q]&.include?("{!lucene}#{Settings.FIELDS.ID}:")

      solr_params[:fq] ||= []
      solr_params[:fq] << "-#{Settings.FIELDS.SUPPRESSED}: true"
      solr_params['admin.api']
    end
  end
end

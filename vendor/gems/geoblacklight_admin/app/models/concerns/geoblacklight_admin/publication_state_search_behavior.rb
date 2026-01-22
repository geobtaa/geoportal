# frozen_string_literal: true

module GeoblacklightAdmin
  module PublicationStateSearchBehavior
    extend ActiveSupport::Concern

    included do
      self.default_processor_chain += [:publication_state_records]
    end

    ##
    # Show/Hide records by publication state in search
    # Defaults to "published" items only
    # publication_state: ['published', 'unpublished', 'draft']
    # @param [Blacklight::Solr::Request]
    # @return [Blacklight::Solr::Request]
    def publication_state_records(solr_params)
      solr_params[:fq] ||= []
      solr_params[:fq] << if blacklight_params["publication_state"]
        "b1g_publication_state_s:#{blacklight_params["publication_state"]}"
      else
        "b1g_publication_state_s:published"
      end
    end
  end
end

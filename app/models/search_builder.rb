class SearchBuilder < Blacklight::SearchBuilder
  include Blacklight::Solr::SearchBuilderBehavior
  include BlacklightAdvancedSearch::AdvancedSearchBuilder
  include B1gDateRangeQueryConcern::RangeLimitBuilder
  include GeoblacklightAdmin::PublicationStateSearchBehavior

  self.default_processor_chain += [:add_advanced_parse_q_to_solr, :add_advanced_search_to_solr]

  include Geoblacklight::SuppressedRecordsSearchBehavior
end

class ApiSearchBuilder < Blacklight::SearchBuilder
  include Blacklight::Solr::SearchBuilderBehavior
  include BlacklightAdvancedSearch::AdvancedSearchBuilder
  include B1gDateRangeQueryConcern::RangeLimitBuilder

  self.default_processor_chain += [:add_advanced_parse_q_to_solr, :add_advanced_search_to_solr]

  # Remove GBL Spatial, otherwise it will hide all suppressed docs
  #   from API search results
  #
  # include Geoblacklight::SpatialSearchBehavior
end

require 'blacklight_range_limit/segment_calculation'

module B1gDateRangeQueryConcern
  module RangeLimitBuilder
    extend ActiveSupport::Concern

    included do
      # Use setters so not to propagate changes
      self.default_processor_chain += [:add_range_limit_params]
    end

    # Method added to to fetch proper things for date ranges.
    def add_range_limit_params(solr_params)
       ranged_facet_configs =
         blacklight_config.facet_fields.select { |key, config| config.range }
       # In ruby 1.8, hash.select returns an array of pairs, in ruby 1.9
       # it returns a hash. Turn it into a hash either way.
       ranged_facet_configs = Hash[ ranged_facet_configs ] unless ranged_facet_configs.kind_of?(Hash)

       ranged_facet_configs.each_pair do |field_key, config|

        range_config = BlacklightRangeLimit.range_config(blacklight_config, config.field)

        hash =  blacklight_params["range"] && blacklight_params["range"][field_key] ?
          blacklight_params["range"][field_key] :
          {}

        if !hash["missing"].blank?
          # missing specified in request params
          solr_params[:fq] ||= []
          solr_params[:fq] << "-#{Settings.FIELDS.DATE_RANGE}:[* TO *]"

        elsif !(hash["begin"].blank? && hash["end"].blank?)
          # specified in request params, begin and/or end, might just have one
          start = hash["begin"].blank? ? "*" : hash["begin"]
          finish = hash["end"].blank? ? "*" : hash["end"]

          solr_params[:fq] ||= []
          solr_params[:fq] << "#{Settings.FIELDS.DATE_RANGE}: [#{start} TO #{finish}]"
        end
      end

      return solr_params
    end
  end
end

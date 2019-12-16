require 'blacklight_range_limit/segment_calculation'

module BlacklightRangeLimit
  module RangeLimitBuilder
    extend ActiveSupport::Concern
    include BlacklightRangeLimit::SegmentCalculation

    # @Customized: Hard codes B1G date range field as range fq param.
    # Method added to to fetch proper things for date ranges.
    def add_range_limit_params(solr_params)
       ranged_facet_configs =
         blacklight_config.facet_fields.select { |key, config| config.range }
       # In ruby 1.8, hash.select returns an array of pairs, in ruby 1.9
       # it returns a hash. Turn it into a hash either way.
       ranged_facet_configs = Hash[ ranged_facet_configs ] unless ranged_facet_configs.kind_of?(Hash)

       ranged_facet_configs.each_pair do |field_key, config|
        solr_params["stats"] = "true"
        solr_params["stats.field"] ||= []
        solr_params["stats.field"] << config.field

        hash =  blacklight_params["range"] && blacklight_params["range"][field_key] ?
          blacklight_params["range"][field_key] :
          {}

        if !hash["missing"].blank?
          # missing specified in request params
          solr_params[:fq] ||= []
          solr_params[:fq] << "-b1g_date_range_drsim:[* TO *]"

        elsif !(hash["begin"].blank? && hash["end"].blank?)
          # specified in request params, begin and/or end, might just have one
          start = hash["begin"].blank? ? "*" : hash["begin"]
          finish = hash["end"].blank? ? "*" : hash["end"]

          solr_params[:fq] ||= []
          solr_params[:fq] << "b1g_date_range_drsim: [#{start} TO #{finish}]"

          if (config.segments != false && start != "*" && finish != "*")
            # Add in our calculated segments, can only do with both boundaries.
            add_range_segments_to_solr!(solr_params, field_key, start.to_i, finish.to_i)
          end

        elsif (config.segments != false &&
               boundaries = config.assumed_boundaries)
          # assumed_boundaries in config
          add_range_segments_to_solr!(solr_params, field_key, boundaries[0], boundaries[1])
        end
      end

      return solr_params
    end

  end
end

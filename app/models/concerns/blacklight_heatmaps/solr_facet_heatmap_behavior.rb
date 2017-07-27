module BlacklightHeatmaps
  ##
  # Extends itself into a consuming application's SearchBuilder and adds
  # relevancy, spatial search, and heatmap functionality.
  module SolrFacetHeatmapBehavior
    extend ActiveSupport::Concern

    included do
      self.default_processor_chain += [:add_solr_facet_heatmap]
    end

    ##
    # Add Solr spatial heatmap parameters to Solr request
    def add_solr_facet_heatmap(solr_parameters = {})
      if blacklight_params[:bbox]
        solr_parameters['facet.heatmap'] = geometry_field
        solr_parameters['facet.heatmap.geom'] = bbox_as_range
        solr_parameters['facet.heatmap.distErrPct'] = dist_err_pct
        solr_parameters[:bq] ||= []
        solr_parameters[:bq] << "#{geometry_field}:\"IsWithin(#{bbox_as_envelope})\""
        solr_parameters[:fq] ||= []
        solr_parameters[:fq] << "#{geometry_field}:\"Intersects(#{bbox_as_envelope})\""
      end
      solr_parameters
    end

    def dist_err_pct
      blacklight_config.heatmap_distErrPct || 0.15
    end

    def geometry_field
      blacklight_config.geometry_field
    end

    ##
    # `bbox` parameter is in format "west,south,east,north"
    # @return Array
    def bbox
      if blacklight_params[:bbox].include?(",")
        bbox = blacklight_params[:bbox].split(',')
      else
        bbox = blacklight_params[:bbox].split(' ')
      end
      bbox
    end

    ##
    # Returned in CQL Envelope syntax
    # https://cwiki.apache.org/confluence/display/solr/Spatial+Search
    # @return String
    def bbox_as_envelope
      BlacklightHeatmaps::BoundingBox.new(*bbox).to_envelope
    end

    ##
    # Returned in rectangle-range syntax ["-180 -90" TO "180 90"]
    # https://cwiki.apache.org/confluence/display/solr/Spatial+Search
    # @return String
    def bbox_as_range
      "[\"#{bbox[0]} #{bbox[1]}\" TO \"#{bbox[2]} #{bbox[3]}\"]"
    end
  end
end

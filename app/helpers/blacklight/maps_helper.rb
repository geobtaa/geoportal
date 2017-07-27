module Blacklight
  module MapsHelper
    ##
    # Creates a div with needed attributes, used to display the index map
    # @return String
    def index_map_div
      content_tag(
        :div,
        nil,
        class: 'blacklight-heatmaps-index-map',
        id: 'index-map',
        data: index_map_data_attributes
      )
    end

    ##
    # The Leaflet template used for constructing the sidebar documents.
    # Variables from returned docs should be keys within curly braces
    # e.g. {title_display}
    # @return String
    def sidebar_template
      <<-HTMLTEMPLATE
      <div class='media'>
        <div class='media-body'>
          <h3 class='media-heading'>
            <a href=\"/catalog/#{blacklight_config.index.identifier_field}\"}>
              {#{blacklight_config.index.title_field}}
            </a>
          </h3>
        </div>
      </div>
      HTMLTEMPLATE
    end

    private

    ##
    # Document path used for creating client side links to documents from a
    # template
    # @return String
    def document_path
      "#{search_catalog_path}/{#{blacklight_config.document_unique_id_param}}"
    end

    ##
    # Data attributes used in displaying the index map
    # @return Hash
    def index_map_data_attributes
      {
        index_map: true,
        basemap_provider: blacklight_config.basemap_provider,
        search_url: request.url,
        geometry_field: blacklight_config.geometry_field,
        sidebar_template: sidebar_template,
        color_ramp: blacklight_config.view.heatmaps.color_ramp
      }
    end
  end
end

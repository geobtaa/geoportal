# -*- encoding : utf-8 -*-
require 'kithe/blacklight_tools/bulk_loading_search_service'

class CatalogController < ApplicationController
  include BlacklightAdvancedSearch::Controller
  include BlacklightRangeLimit::ControllerOverride
  include Blacklight::Catalog

  # GBL Admin
  self.search_service_class = Kithe::BlacklightTools::BulkLoadingSearchService

  configure_blacklight do |config|
    # default advanced config values
    config.advanced_search.enabled = true
    config.advanced_search ||= Blacklight::OpenStructWithHashAccess.new


    # Blacklight update to 7.0.0
    config.add_results_document_tool(:bookmark, partial: 'bookmark_control', if: :render_bookmarks_control?)

    config.add_results_collection_tool(:sort_widget)
    config.add_results_collection_tool(:per_page_widget)
    config.add_results_collection_tool(:view_type_group)

    config.add_show_tools_partial(:bookmark, partial: 'bookmark_control', if: :render_bookmarks_control?)
    config.add_show_tools_partial(:email, callback: :email_action, validator: :validate_email_params)
    config.add_show_tools_partial(:sms, if: :render_sms_action?, callback: :sms_action, validator: :validate_sms_params)

    config.add_nav_action(:bookmark, partial: 'blacklight/nav/bookmark', if: :render_bookmarks_control?)
    # Blacklight update to 7.0.0

    # Advanced config values
    config.advanced_search ||= Blacklight::OpenStructWithHashAccess.new
    config.advanced_search[:url_key] ||= 'advanced'
    config.advanced_search[:query_parser] ||= 'edismax'
    config.advanced_search[:form_solr_parameters] ||= {}
    config.advanced_search[:form_solr_parameters]['facet.field'] ||= [Settings.FIELDS.PROVIDER, Settings.FIELDS.RESOURCE_TYPE, Settings.FIELDS.RESOURCE_CLASS]
    config.advanced_search[:form_solr_parameters]['facet.query'] ||= ''
    config.advanced_search[:form_solr_parameters]['facet.limit'] ||= -1
    config.advanced_search[:form_solr_parameters]['facet.sort'] ||= 'index'

    # @See: https://github.com/geobtaa/geoportal/issues/471
    # The 'facet.limit' -1 value is not respected here, catalog_controller.rb configuration facet limits are still passed along to Solr. This manually adjusts the facet count to -1 for schema_provider_s and gbl_resourceType_sm
    config.advanced_search[:form_solr_parameters]['f.schema_provider_s.facet.limit'] ||= -1
    config.advanced_search[:form_solr_parameters]['f.gbl_resourceType_sm.facet.limit'] ||= -1

    # GeoBlacklight Defaults
    # * Adds the "map" split view for catalog#index
    # config.view.split(partials: ['index'])
    config.view.delete_field('list')

    # Map views
    config.view.mapview.partials = [:index]
    # config.view['split'].title = "List view"
    # config.view['mapview'].title = "Map view"

    config.raw_endpoint.enabled = true

    # Blacklight::Allmaps Viewer
    config.default_solr_unique_key = "geomg_id_s"
    config.default_georeferenced_field = "b1g_georeferenced_allmaps_b"

    ## Default parameters to send to solr for all search-like requests. See also SolrHelper#solr_search_params
    config.default_solr_params = {
      :start => 0,
      'q.alt' => '*:*',
      'fl' => '*,score,[explain]',
      'bf' => ["if(exists(#{Settings.FIELDS.B1G_CHILD_RECORD}),0,100)^0.5"]
    }

    config.per_page = [10, 20, 50]
    config.max_per_page = 50
    config.default_per_page = 10

    ## Default parameters to send on single-document requests to Solr. These settings are the Blackligt defaults (see SolrHelper#solr_doc_params) or
    ## parameters included in the Blacklight-jetty document requestHandler.
    #
    config.default_document_solr_params = {
     :qt => 'document',
     :q => "{!raw f=#{Settings.FIELDS.B1G_GEOMG_ID} v=$id}"
    }

    # solr field configuration for search results/index views
    # config.index.show_link = 'title_display'
    # config.index.record_display_type = 'format'

    config.index.title_field = Settings.FIELDS.TITLE
    config.index.document_presenter_class = Geoblacklight::DocumentPresenter

    # solr field configuration for document/show views

    config.show.display_type_field = 'format'

    # Custom GeoBlacklight fields which currently map to GeoBlacklight-Schema
    # v0.3.2
    config.wxs_identifier_field = Settings.FIELDS.WXS_IDENTIFIER

    # solr fields that will be treated as facets by the blacklight application
    #   The ordering of the field names is the order of the display
    #
    # Setting a limit will trigger Blacklight's 'more' facet values link.
    # * If left unset, then all facet values returned by solr will be displayed.
    # * If set to an integer, then "f.somefield.facet.limit" will be added to
    # solr request, with actual solr request being +1 your configured limit --
    # you configure the number of items you actually want _displayed_ in a page.
    # * If set to 'true', then no additional parameters will be sent to solr,
    # but any 'sniffed' request limit parameters will be used for paging, with
    # paging at requested limit -1. Can sniff from facet.limit or
    # f.specific_field.facet.limit solr request params. This 'true' config
    # can be used if you set limits in :default_solr_params, or as defaults
    # on the solr side in the request handler itself. Request handler defaults
    # sniffing requires solr requests to be made with "echoParams=all", for
    # app code to actually have it echo'd back to see it.
    #
    # :show may be set to false if you don't want the facet to be drawn in the
    # facet bar
    # config.add_facet_field 'format', :label => 'Format'
    # config.add_facet_field 'pub_date', :label => 'Publication Year', :single => true
    # config.add_facet_field 'subject_topic_facet', :label => 'Topic', :limit => 20
    # config.add_facet_field 'language_facet', :label => 'Language', :limit => true
    # config.add_facet_field 'lc_1letter_facet', :label => 'Call Number'
    # config.add_facet_field 'subject_geo_facet', :label => 'Region'
    # config.add_facet_field 'solr_bbox', :fq => "solr_bbox:IsWithin(-88,26,-79,36)", :label => 'Spatial'

    # config.add_facet_field 'example_pivot_field', :label => 'Pivot Field', :pivot => ['format', 'language_facet']

    config.add_facet_field Settings.FIELDS.SPATIAL_COVERAGE, :label => 'Place', :limit => 8, collapse: false
    config.add_facet_field Settings.FIELDS.RESOURCE_CLASS, :label => 'Resource Class', :limit => 8, collapse: false
    config.add_facet_field Settings.FIELDS.RESOURCE_TYPE, label: 'Resource Type', limit: 8, collapse: false

    config.add_facet_field Settings.FIELDS.INDEX_YEAR, label: 'Year', limit: 10, collapse: false, all: 'Any year', range: {
      assumed_boundaries: [1100, 2018]
      # :num_segments => 6,
      # :segments => true
    }

    config.add_facet_field 'time_period', label: 'Time Period', query: {
      '2020-present' => { label: '2020-present', fq: "#{Settings.FIELDS.INDEX_YEAR}:[2020 TO #{Time.now.year}]"},
      '2015-2019' => { label: '2015-2019', fq: "#{Settings.FIELDS.INDEX_YEAR}:[2015 TO 2019]"},
      '2010-2014' => { label: '2010-2014', fq: "#{Settings.FIELDS.INDEX_YEAR}:[2010 TO 2014]" },
      '2005-2009' => { label: '2005-2009', fq: "#{Settings.FIELDS.INDEX_YEAR}:[2005 TO 2009]" },
      '2000-2004' => { label: '2000-2004', fq: "#{Settings.FIELDS.INDEX_YEAR}:[2000 TO 2004]" },
      '1950-1999' => { label: '1950-1999', fq: "#{Settings.FIELDS.INDEX_YEAR}:[1950 TO 1999]" },
      '1900-1949' => { label: '1900-1949', fq: "#{Settings.FIELDS.INDEX_YEAR}:[1900 TO 1949]" },
      '1850-1899' => { label: '1850-1899', fq: "#{Settings.FIELDS.INDEX_YEAR}:[1850 TO 1899]" },
      '1800-1849' => { label: '1800-1849', fq: "#{Settings.FIELDS.INDEX_YEAR}:[1800 TO 1849]" },
      '1700s' => { label: '1700s', fq: "#{Settings.FIELDS.INDEX_YEAR}:[1700 TO 1799]" },
      '1600s' => { label: '1600s', fq: "#{Settings.FIELDS.INDEX_YEAR}:[1600 TO 1699]" },
      '1500s' => { label: '1500s', fq: "#{Settings.FIELDS.INDEX_YEAR}:[1500 TO 1599]" },
      '1400s-earlier' => { label: '1400s-earlier', fq: "#{Settings.FIELDS.INDEX_YEAR}:[ -999999999 TO 1499]" },
    }, collapse: false

    config.add_facet_field Settings.FIELDS.B1G_LANGUAGE, label: 'Language', limit: 15
    config.add_facet_field Settings.FIELDS.CREATOR, :label => 'Creator', :limit => 8
    config.add_facet_field Settings.FIELDS.PROVIDER, label: 'Provider', limit: 15
    config.add_facet_field Settings.FIELDS.B1G_LOCAL_COLLECTION_LABEL, label: 'Local Collection', limit: 15
    config.add_facet_field Settings.FIELDS.ACCESS_RIGHTS, :label => 'Public/Restricted'
    config.add_facet_field Settings.FIELDS.B1G_MEDIATOR, label: 'Institutional Access', limit: 15
    config.add_facet_field Settings.FIELDS.GEOREFERENCED, label: 'Downloadable GeoTIFF'
    config.add_facet_field Settings.FIELDS.B1G_GEOREFERENCED_ALLMAPS, label: 'Map Overlay'

    # GEOBLACKLIGHT APPLICATION FACETS

    # Map-Based "Search Here" Feature
    # item_presenter       - Defines how the facet appears in the GBL UI
    # filter_query_builder - Defines the query generated for Solr
    # filter_class         - Defines how to add/remove facet from query
    # label                - Defines the label used in contstraints container
    config.add_facet_field 'solr_bboxtype', item_presenter: Geoblacklight::BboxItemPresenter, filter_class: Geoblacklight::BboxFilterField, filter_query_builder: Geoblacklight::BboxFilterQuery, within_boost: Settings.BBOX_WITHIN_BOOST, overlap_boost: Settings.OVERLAP_RATIO_BOOST, overlap_field: Settings.FIELDS.OVERLAP_FIELD, label: 'Bounding Box'
    config.add_facet_field Settings.FIELDS.B1G_IMPORT_ID, label: "Import ID", show: false

    # Item Relationship Facets
    # * Not displayed to end user (show: false)
    # * Must be present for facet filter queries to work
    # * Must be present for "Browse all 4 records..." links to work
    config.add_facet_field Settings.FIELDS.MEMBER_OF, :label => 'Member Of', :limit => 8, collapse: false, show: false
    config.add_facet_field Settings.FIELDS.IS_PART_OF, :label => 'Is Part Of', :limit => 8, collapse: false, show: false
    config.add_facet_field Settings.FIELDS.RELATION, :label => 'Related', :limit => 8, collapse: false, show: false
    config.add_facet_field Settings.FIELDS.REPLACES, :label => 'Replaces', :limit => 8, collapse: false, show: false
    config.add_facet_field Settings.FIELDS.IS_REPLACED_BY, :label => 'Is Replaced By', :limit => 8, collapse: false, show: false
    config.add_facet_field Settings.FIELDS.SOURCE, :label => 'Source', :limit => 8, collapse: false, show: false
    config.add_facet_field Settings.FIELDS.VERSION, :label => 'Is Version Of', :limit => 8, collapse: false, show: false

    # Other hidden Facets
    config.add_facet_field Settings.FIELDS.THEME, :label => 'Theme', :limit => 8, collapse: false, show: false

    # Remove access facet until data is available - EWL
    # config.add_facet_field 'dc_rights_s', label: 'Access', limit: 8, partial: "icon_facet"

    # Have BL send all facet field names to Solr, which has been the default
    # previously. Simply remove these lines if you'd rather use Solr request
    # handler defaults, or have no facets.
    config.add_facet_fields_to_solr_request!

    # solr fields to be displayed in the index (search results) view
    #   The ordering of the field names is the order of the display
    # config.add_index_field 'title_display', :label => 'Title:'
    # config.add_index_field 'title_vern_display', :label => 'Title:'
    # config.add_index_field 'author_display', :label => 'Author:'
    # config.add_index_field 'author_vern_display', :label => 'Author:'
    # config.add_index_field 'format', :label => 'Format:'
    # config.add_index_field 'language_facet', :label => 'Language:'
    # config.add_index_field 'published_display', :label => 'Published:'
    # config.add_index_field 'published_vern_display', :label => 'Published:'
    # config.add_index_field 'lc_callnum_display', :label => 'Call number:'

    config.add_index_field Settings.FIELDS.TEMPORAL_COVERAGE
    config.add_index_field Settings.FIELDS.CREATOR
    config.add_index_field Settings.FIELDS.DESCRIPTION, helper_method: :snippit
    config.add_index_field Settings.FIELDS.PUBLISHER

    # Relevancy Debugging
    config.add_index_field 'score', helper_method: :score_output
    config.add_index_field '[explain]', helper_method: :debug_output

    # solr fields to be displayed in the show (single result) view
    #  The ordering of the field names is the order of the display
    #
    # item_prop: [String] property given to span with Schema.org item property
    # link_to_facet: [Boolean] that can be passed to link to a facet search
    # helper_method: [Symbol] method that can be used to render the value
    config.add_show_field Settings.FIELDS.TITLE, label: 'Title'
    config.add_show_field Settings.FIELDS.DESCRIPTION, label: 'Description', itemprop: 'description', helper_method: :render_value_as_truncate_abstract_new_lines
    config.add_show_field Settings.FIELDS.CREATOR, label: 'Creator', itemprop: 'creator'
    config.add_show_field Settings.FIELDS.PUBLISHER, label: 'Publisher', itemprop: 'publisher'
    config.add_show_field Settings.FIELDS.PROVIDER, label: 'Provider', link_to_facet: true
    config.add_show_field Settings.FIELDS.B1G_LOCAL_COLLECTION_LABEL, label: 'Local Collection', link_to_facet: true
	  config.add_show_field Settings.FIELDS.RESOURCE_CLASS, label: 'Resource Class', itemprop: 'class', link_to_facet: true
    config.add_show_field Settings.FIELDS.RESOURCE_TYPE, label: 'Resource Type', itemprop: 'type', link_to_facet: true
    config.add_show_field Settings.FIELDS.SUBJECT, label: 'Subject', itemprop: 'keywords'
    config.add_show_field Settings.FIELDS.THEME, label: 'Theme', itemprop: 'theme', link_to_facet: true
    config.add_show_field Settings.FIELDS.TEMPORAL_COVERAGE, label: 'Temporal Coverage', itemprop: 'temporal'
    config.add_show_field Settings.FIELDS.DATE_ISSUED, label: 'Date Issued', itemprop: 'issued'
    config.add_show_field Settings.FIELDS.SPATIAL_COVERAGE, label: 'Place', itemprop: 'spatial', link_to_facet: true, helper_method: :render_placenames_as_truncate_abstract
    config.add_show_field Settings.FIELDS.RIGHTS, label: 'Rights', itemprop: 'rights', helper_method: :render_value_as_truncate_abstract_new_lines
    config.add_show_field Settings.FIELDS.RIGHTS_HOLDER, label: 'Rights Holder', itemprop: 'rights_holder'
    config.add_show_field Settings.FIELDS.LICENSE, label: 'License', itemprop: 'license'
    config.add_show_field Settings.FIELDS.ACCESS_RIGHTS, label: 'Access Rights', itemprop: 'access_rights'
    config.add_show_field Settings.FIELDS.FORMAT, label: 'Format', itemprop: 'format'
    config.add_show_field Settings.FIELDS.FILE_SIZE, label: 'File Size', itemprop: 'file_size'
    config.add_show_field Settings.FIELDS.B1G_LANGUAGE, label: 'Language', itemprop: 'language'
    config.add_show_field Settings.FIELDS.B1G_DATE_CREATED, label: 'Date Added', helper_method: :render_date_created
    config.add_show_field Settings.FIELDS.B1G_DCT_CONFORMS_TO, label: 'Conforms To', itemprop: 'conforms_to'
    config.add_show_field Settings.FIELDS.B1G_DCAT_SPATIAL_RESOLUTION_IN_METERS, label: 'Spatial Resolution in Meters', itemprop: 'dcat_spatial_resolution'
    config.add_show_field Settings.FIELDS.B1G_GEODCAT_SPATIAL_RESOLUTION_AS_TEXT, label: 'Spatial Resolution as Text', itemprop: 'geodcat_spatial_resolution'
    config.add_show_field Settings.FIELDS.B1G_DCT_PROVENANCE_STATEMENT, label: 'Provenance Statement', itemprop: 'provenance_statement'
    config.add_show_field Settings.FIELDS.B1G_DCT_EXTENT, label: 'Extent in square kilometers', itemprop: 'extent'

    # "fielded" search configuration. Used by pulldown among other places.
    # For supported keys in hash, see rdoc for Blacklight::SearchFields
    #
    # Search fields will inherit the :qt solr request handler from
    # config[:default_solr_parameters], OR can specify a different one
    # with a :qt key/value. Below examples inherit, except for subject
    # that specifies the same :qt as default for our own internal
    # testing purposes.
    #
    # The :key is what will be used to identify this BL search field internally,
    # as well as in URLs -- so changing it after deployment may break bookmarked
    # urls.  A display label will be automatically calculated from the :key,
    # or can be specified manually to be different.

    # This one uses all the defaults set by the solr request handler. Which
    # solr request handler? The one set in config[:default_solr_parameters][:qt],
    # since we aren't specifying it otherwise.

    config.add_search_field('all_fields') do |field|
      field.include_in_advanced_search = false
      field.label = 'All Fields'
    end

    config.add_search_field('keyword') do |field|
      field.include_in_simple_select = false
      field.qt = 'search'
      field.label = 'Keyword'
      field.solr_local_parameters = {
        qf: '$qf',
        pf: '$pf'
      }
    end

    config.add_search_field('title') do |field|
      field.include_in_simple_select = false
      field.qt = 'search'
      field.label = 'Title'
      field.solr_local_parameters = {
        qf: '$title_qf',
        pf: '$title_pf'
      }
    end

    config.add_search_field('placename') do |field|
      field.include_in_simple_select = false
      field.qt = 'search'
      field.label = 'Place'
      field.solr_local_parameters = {
        qf: '$placename_qf',
        pf: '$placename_pf'
      }
    end

    config.add_search_field('publisher') do |field|
      field.include_in_simple_select = false
      field.qt = 'search'
      field.label = 'Publisher/Creator'
      field.solr_local_parameters = {
        qf: '$publisher_qf',
        pf: '$publisher_pf'
      }
    end

    # "sort results by" select (pulldown)
    # label in pulldown is followed by the name of the SOLR field to sort by and
    # whether the sort is ascending or descending (it must be asc or desc
    # except in the relevancy case).
    config.add_sort_field 'score desc, dct_title_sort asc', :label => 'Relevance'
    config.add_sort_field "#{Settings.FIELDS.INDEX_YEAR} desc, dct_title_sort asc", :label => 'Year (Newest first)'
    config.add_sort_field "#{Settings.FIELDS.INDEX_YEAR} asc, dct_title_sort asc", :label => 'Year (Oldest first)'
    config.add_sort_field 'dct_title_sort asc', :label => 'Title (A-Z)'
    config.add_sort_field 'dct_title_sort desc', :label => 'Title (Z-A)'
    config.add_sort_field 'date_created_dtsi desc', :label => 'Date added (Newest first)'
    config.add_sort_field 'date_created_dtsi asc', :label => 'Date added (Oldest first)'

    # If there are more than this many search results, no spelling ("did you
    # mean") suggestion is offered.
    config.spell_max = 5

    # Custom tools for GeoBlacklight
    config.add_show_tools_partial :more_details, partial: 'show_more_details', if: proc { |_context, _config, options| options[:document] && (!options[:document].references.nil? & !options[:document].references.url.nil?)}
    config.add_show_tools_partial :metadata, if: proc { |_context, _config, options| options[:document] && (Settings.METADATA_SHOWN & options[:document].references.refs.map(&:type).map(&:to_s)).any? }
    config.add_show_tools_partial :gbl_admin_data_dictionaries, partial: 'gbl_admin_data_dictionaries', if: proc { |_context, _config, options| options[:document] && options[:document]&.kithe_model&.document_data_dictionaries&.present? }
    config.add_show_tools_partial :arcgis, partial: 'arcgis', if: proc { |_context, _config, options| options[:document] && options[:document].arcgis_urls.present? }
    config.add_show_tools_partial :data_dictionary, partial: 'data_dictionary', if: proc { |_context, _config, options| options[:document] && options[:document].data_dictionary_download.present? }
    config.add_show_tools_partial(:access_links, partial: 'access_links', if: proc { |_context, _config, options| options[:document] && options[:document].access_links.present?})


    # Remove nav actions
    config.add_nav_action(:bookmark, partial: 'blacklight/nav/bookmark', if: false)

    # Remove show tools
    config.show.partials.delete(:show_header)
    config.show.partials.delete(:show)
    config.show.partials.delete(:more_like_this)
    config.show.partials.delete(:document_metadata)

    config.show.display_type_field = 'format'
    config.show.partials << "show_header_default"
    config.show.partials << "show_default_display_note"
    config.show.partials << "show_default_viewer_container"
    config.show.partials << "show_default_viewer_information"
    config.show.partials << "show_default_attribute_table"
    config.show.partials << "show_document_full_details"
    config.show.partials << :show


    config.show.document_actions.delete(:email)
    config.show.document_actions.delete(:bookmark)
    config.show.document_actions.delete(:sms)

    # Configure basemap provider for GeoBlacklight maps (uses https only basemap
    # providers with open licenses)
    # Valid basemaps include:
    # 'mapquest' http://developer.mapquest.com/web/products/open/map
    # 'positron' http://cartodb.com/basemaps/
    # 'darkMatter' http://cartodb.com/basemaps/
    config.basemap_provider = 'openstreetmapStandard'

    # Configuration for autocomplete suggestor
    config.autocomplete_enabled = true
    config.autocomplete_path = 'suggest'
  end

  def web_services
    @response, @documents = action_documents

    respond_to do |format|
      format.html do
        return render layout: false if request.xhr?
        # Otherwise draw the full page
      end
    end
  end

  def data_dictionaries
    @response, @documents = action_documents
    respond_to do |format|
      format.html do
        return render layout: false if request.xhr?
        # Otherwise draw the full page 
      end   
    end     
  end

  # Administrative view of document
  # - Sidecar Image
  # - URIs
  def admin
    deprecated_response, @document = search_service.fetch(params[:id])
  end
end

# -*- encoding : utf-8 -*-
require 'blacklight/catalog'

module Admin
  class IdsController < ApplicationController
    include BlacklightAdvancedSearch::Controller
    include BlacklightRangeLimit::ControllerOverride
    include Blacklight::Catalog

    configure_blacklight do |config|
      # special search builder / fails
      config.search_builder_class = ApiSearchBuilder

      # default advanced config values
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
      config.advanced_search[:form_solr_parameters]['facet.field'] ||= [Settings.FIELDS.PROVIDER, Settings.FIELDS.B1G_CODE, Settings.FIELDS.MEMBER_OF, Settings.FIELDS.IS_PART_OF, Settings.FIELDS.RESOURCE_CLASS, Settings.FIELDS.RESOURCE_TYPE, Settings.FIELDS.SUBJECT, Settings.FIELDS.THEME, Settings.FIELDS.FORMAT, Settings.FIELDS.SUPPRESSED, Settings.FIELDS.B1G_CHILD_RECORD, Settings.FIELDS.GEOREFERENCED]
      config.advanced_search[:form_solr_parameters]['facet.query'] ||= ''
      config.advanced_search[:form_solr_parameters]['facet.limit'] ||= -1
      config.advanced_search[:form_solr_parameters]['facet.sort'] ||= 'index'

      # Map views
      config.view.mapview.partials = [:index]
      config.view['split'].title = "List view"
      config.view['mapview'].title = "Map view"

      config.raw_endpoint.enabled = true

      ## Default parameters to send to solr for all search-like requests. See also SolrHelper#solr_search_params
      config.default_solr_params = {
        :start => 0,
        'q.alt' => '*:*',
        'bf' => ["if(exists(#{Settings.FIELDS.B1G_CHILD_RECORD}),0,100)^0.5"],
        'admin.api' => true
      }

      config.default_per_page = 1000 # Works!

      ## Default parameters to send on single-document requests to Solr. These settings are the Blackligt defaults (see SolrHelper#solr_doc_params) or
      ## parameters included in the Blacklight-jetty document requestHandler.
      #
      config.default_document_solr_params = {
       :qt => 'document',
       :q => "{!raw f=#{Settings.FIELDS.B1G_GEOMG_ID} v=$id}"
      }

      # config.search_builder_class = Geoblacklight::SearchBuilder

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

      ## FACETS
      #
      # Date Range Filter
      config.add_facet_field 'date_created_drsim', :label => 'Date Created', :show => false

      # Date Created
      config.add_facet_field 'time_period', label: 'Date Created', query: {
        'today' => { label: 'Today', fq: "date_created_drsim:[#{Date.today.beginning_of_day.to_time.strftime('%Y-%m-%dT%H:%M:%S')} TO #{Date.today.end_of_day.to_time.strftime('%Y-%m-%dT%H:%M:%S')}]"},
        'this_week' => { label: 'This week', fq: "date_created_drsim:[#{(Date.today.end_of_day - 1.week).to_time.strftime('%Y-%m-%dT%H:%M:%S')} TO  #{Date.today.end_of_day.to_time.strftime('%Y-%m-%dT%H:%M:%S')}]"},
        'this_month' => { label: 'This month', fq: "date_created_drsim:[#{(Date.today.end_of_day - 1.month).to_time.strftime('%Y-%m-%dT%H:%M:%S')} TO  #{Date.today.end_of_day.to_time.strftime('%Y-%m-%dT%H:%M:%S')}]"},
        'last_month' => { label: 'Last month', fq: "date_created_drsim:[#{(Date.today.end_of_day - 2.months).to_time.strftime('%Y-%m-%dT%H:%M:%S')} TO  #{(Date.today.end_of_day - 1.month).to_time.strftime('%Y-%m-%dT%H:%M:%S')}]"},
        'this_quarter' => { label: 'This quarter', fq: "date_created_drsim:[#{(Date.today.end_of_day - 3.months).to_time.strftime('%Y-%m-%dT%H:%M:%S')} TO  #{(Date.today.end_of_day).to_time.strftime('%Y-%m-%dT%H:%M:%S')}]"},
        'this_year' => { label: 'This year', fq: "date_created_drsim:[#{(Date.today.end_of_day - 1.year).to_time.strftime('%Y-%m-%dT%H:%M:%S')} TO  #{(Date.today.end_of_day).to_time.strftime('%Y-%m-%dT%H:%M:%S')}]"}
      }

      # Publication State
      config.add_facet_field Settings.FIELDS.B1G_PUBLICATION_STATE, show: false

      # Resouce Class
      config.add_facet_field Settings.FIELDS.RESOURCE_CLASS, show: false

      # Contributor
      config.add_facet_field Settings.FIELDS.PROVIDER, show: false

      # Accrual Method
      config.add_facet_field Settings.FIELDS.B1G_ACCRUAL_METHOD, show: false

      # Public/Restricted
      config.add_facet_field Settings.FIELDS.ACCESS_RIGHTS, show: false

      # ADVANCED SEARCH
      #
      # Code
      config.add_facet_field Settings.FIELDS.B1G_CODE, label: 'Code', limit: 1000

      # Is Part Of
      config.add_facet_field Settings.FIELDS.IS_PART_OF, label: 'Is Part Of', limit: 1000

      # Member Of
      config.add_facet_field Settings.FIELDS.MEMBER_OF, label: 'Member Of', limit: 1000

      # Resource Type
      config.add_facet_field Settings.FIELDS.RESOURCE_TYPE, label: 'Resource Type', limit: 1000

      # Subject
      config.add_facet_field Settings.FIELDS.SUBJECT, label: 'Subject', limit: 1000

      # Theme
      config.add_facet_field Settings.FIELDS.THEME, label: 'Theme', limit: 1000

      # Format
      config.add_facet_field Settings.FIELDS.FORMAT, label: 'Format', limit: 1000

      # Suppressed
      config.add_facet_field Settings.FIELDS.SUPPRESSED, label: 'Suppressed'

      # Child Record
      config.add_facet_field Settings.FIELDS.B1G_CHILD_RECORD, label: 'Child Record'

      # Georeferenced
      config.add_facet_field Settings.FIELDS.GEOREFERENCED, label: 'Georeferenced'

      # Have BL send all facet field names to Solr, which has been the default
      # previously. Simply remove these lines if you'd rather use Solr request
      # handler defaults, or have no facets.
      # config.add_facet_fields_to_solr_request!

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

      # config.add_index_field Settings.FIELDS.TITLE, :label => 'Title:'
      # config.add_index_field Settings.FIELDS.B1G_GEOMG_ID, :label => 'Identifier:'
      # config.add_index_field Settings.FIELDS.PROVIDER, :label => 'Institution:'
      # config.add_index_field Settings.FIELDS.ACCESS_RIGHTS, :label => 'Access:'
      # config.add_index_field Settings.FIELDS.SUBJECT, :label => 'Keywords:'
      # config.add_index_field Settings.FIELDS.CENTROID, :label => 'Centroid:'
      # config.add_index_field Settings.FIELDS.INDEX_YEAR
      # config.add_index_field Settings.FIELDS.CREATOR
      # config.add_index_field Settings.FIELDS.DESCRIPTION, helper_method: :snippit
      # config.add_index_field Settings.FIELDS.PUBLISHER
      # config.add_index_field Settings.FIELDS.SUPPRESSED, :label => 'Suppressed:'

      # solr fields to be displayed in the show (single result) view
      #  The ordering of the field names is the order of the display
      #
      # item_prop: [String] property given to span with Schema.org item property
      # link_to_facet: [Boolean] that can be passed to link to a facet search
      # helper_method: [Symbol] method that can be used to render the value
      # config.add_show_field Settings.FIELDS.CREATOR, label: 'Creator', itemprop: 'creator'
      # config.add_show_field Settings.FIELDS.DESCRIPTION, label: 'Description', itemprop: 'description', helper_method: :render_value_as_truncate_abstract
      # config.add_show_field Settings.FIELDS.PUBLISHER, label: 'Publisher', itemprop: 'publisher', link_to_facet: true
      # config.add_show_field Settings.FIELDS.SPATIAL_COVERAGE, label: 'Place', itemprop: 'spatial', link_to_facet: true, helper_method: :render_placenames_as_truncate_abstract
      # config.add_show_field Settings.FIELDS.SUBJECT, label: 'Subject', itemprop: 'keywords', link_to_facet: true
      # config.add_show_field Settings.FIELDS.RESOURCE_TYPE, label: 'Type', itemprop: 'keywords', link_to_facet: true
      # config.add_show_field Settings.FIELDS.DATE_ISSUED, label: 'Date # Published', itemprop: 'keywords', link_to_facet: true
      # config.add_show_field Settings.FIELDS.TEMPORAL_COVERAGE, label: 'Temporal Coverage', itemprop: 'temporal'
      # config.add_show_field Settings.FIELDS.PROVIDER, label: 'Contributed by', link_to_facet: true
      # config.add_show_field Settings.FIELDS.RIGHTS, label: 'Access Rights'

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
      config.add_sort_field 'score desc, dct_title_sort asc', :label => 'relevance'
      config.add_sort_field "#{Settings.FIELDS.INDEX_YEAR} desc, dct_title_sort asc", :label => 'year'
      config.add_sort_field 'dct_title_sort asc', :label => 'title'

      # If there are more than this many search results, no spelling ("did you
      # mean") suggestion is offered.
      config.spell_max = 5

      # Custom tools for GeoBlacklight
      config.add_show_tools_partial :more_details, partial: 'more_details', if: proc { |_context, _config, options| options[:document] && (!options[:document].references.nil? & !options[:document].references.url.nil?)}
      config.add_show_tools_partial :metadata, if: proc { |_context, _config, options| options[:document] && (Settings.METADATA_SHOWN & options[:document].references.refs.map(&:type).map(&:to_s)).any? }
      config.add_show_tools_partial :web_services, if: proc { |_context, _config, options| options[:document] && (Settings.WEBSERVICES_SHOWN & options[:document].references.refs.map(&:type).map(&:to_s)).any? }
      config.add_show_tools_partial :exports, partial: 'exports', if: proc { |_context, _config, options| options[:document] }
      config.add_show_tools_partial :data_dictionary, partial: 'data_dictionary', if: proc { |_context, _config, options| options[:document] && options[:document].data_dictionary_download.present?}
      config.add_show_tools_partial(:citation)
      config.add_show_tools_partial(:access_links, partial: 'access_links', if: proc { |_context, _config, options| options[:document] && options[:document].access_links.present?})

      # Remove nav actions
      config.add_nav_action(:bookmark, partial: 'blacklight/nav/bookmark', if: false)

      # Remove show tools
      config.show.partials.delete(:show_header)
      config.show.partials.delete(:show)

      config.show.display_type_field = 'format'
      config.show.partials << 'show_header'
      config.show.partials << 'show_default_viewer_container'
      config.show.partials << 'show_default_viewer_information'
      config.show.partials << 'show_default_attribute_table'
      config.show.partials << 'show'


      config.show.document_actions.delete(:email)
      config.show.document_actions.delete(:bookmark)
      config.show.document_actions.delete(:sms)

      # Configure basemap provider for GeoBlacklight maps (uses https only basemap
      # providers with open licenses)
      # Valid basemaps include:
      # 'mapquest' http://developer.mapquest.com/web/products/open/map
      # 'positron' http://cartodb.com/basemaps/
      # 'darkMatter' http://cartodb.com/basemaps/
      config.basemap_provider = 'esri'
      config.max_per_page = 100000

      # Configuration for autocomplete suggestor
      config.autocomplete_enabled = true
      config.autocomplete_path = 'suggest'
    end

    # Administrative view of document
    # - Sidecar Image
    # - URIs
    def admin
      deprecated_response, @document = search_service.fetch(params[:id])
    end

    # Administrative view for array of document ids
    # - bookmarks
    def fetch
      @response, deprecated_document_list = search_service.fetch(params[:id])

      respond_to do |format|
        format.json do
          @presenter = Blacklight::JsonPresenter.new(@response,
                                                     blacklight_config)
        end
      end
    end

    # Administrative view of adv search facets
    def advanced_search_facets
      # We want to find the facets available for the current search, but:
      # * IGNORING current query (add in facets_for_advanced_search_form filter)
      # * IGNORING current advanced search facets (remove add_advanced_search_to_solr filter)
      @response, _ = search_service.search_results do |search_builder|
        search_builder.except(:add_advanced_search_to_solr).append(:facets_for_advanced_search_form)
      end

      @response

      respond_to do |format|
        format.json do
          @presenter = Blacklight::JsonPresenter.new(@response,
                                                     blacklight_config)
        end
      end
    end
  end
end

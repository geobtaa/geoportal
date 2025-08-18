require 'chronic'

module ApplicationHelper

  # Always return an array of geom type values
  def geom_types(types)
    types = [*types]
  end

  def localized_image_path(url_hash)
    Rails.root.join("public/uploads/localized/#{url_hash}")
  end

  def remote_image_link(url)
    url_hash = Digest::MD5.hexdigest(url)
    if File.exist? localized_image_path(url_hash)
      geoportal_image_link = asset_url("uploads/localized/#{url_hash}", skip_pipeline: true)
    else
      external_image_link = url
      LocalizeImageJob.perform_later(url)
      external_image_link
    end
  end

  def homepage?
    current_page?(root_url) && has_search_parameters? == false
  end

  def citation_date(date_string)
    date_value = ""

    if date_string.blank?
      date_value = 'n.d.'
    elsif date_string&.size == 4
      date_value = date_string
    elsif date_string&.match?(/[-|:|\/]/)
      begin
        date_value = Chronic.parse(date_string).to_date.strftime('%Y')
      rescue
        begin
          # Capture YYYY from '2004-01-00' / the '00' day value breaks Chronic
          date_value = date_string.split("-")[0]
        rescue
          date_value = date_string
        end
      end
    else
      date_value = date_string
    end

    # Guard against unknown dates
    if date_value == '9999'
      date_value = 'n.d.'
    end

    date_value
  end

  def b1g_institution_codes
    {
      '01'=> 'Indiana University',
      '02'=> 'University of Illinois Urbana-Champaign',
      '03'=> 'University of Iowa',
      '04'=> 'University of Maryland',
      '05'=> 'University of Minnesota',
      '06'=> 'Michigan State University',
      '07'=> 'University of Michigan',
      '08'=> 'Purdue University',
      '09'=> 'Pennsylvania State University',
      '10'=> 'University of Wisconsin-Madison',
      '11'=> 'The Ohio State University',
      '12'=> 'University of Chicago',
      '13'=> 'University of Nebraska-Lincoln',
      '14'=> 'Rutgers University-New Brunswick',
      "15" => "Northwestern University"
    }
  end

  def b1g_access_links(document)
    links = {}
    document.access_links.each do |key,value|
      links[b1g_institution_codes[key]] = value
    end

    links.sort.to_h
  end

  ## Render date_created
  def render_date_created(args)
    args[:value]&.first&.to_date&.strftime("%Y-%m-%d")
  end

  ##
  # Render value for a document's field as a truncate abstract
  # div. Arguments come from Blacklight::DocumentPresenter's
  # get_field_values method
  # @param [Hash] args from get_field_values
  def render_value_as_truncate_abstract_new_lines(args)
    tag.div class: 'truncate-abstract' do
      if args[:config].itemprop
        tag.span itemprop: args[:config].itemprop do
          Array(args[:value]).flatten.join("\n")
        end
      else
        Array(args[:value]).flatten.join("\n")
      end
    end
  end

  ##
  # Render value for a document's field as a truncate abstract
  # div. Arguments come from Blacklight::DocumentPresenter's
  # get_field_values method
  # @param [Hash] args from get_field_values
  def render_placenames_as_truncate_abstract(args)
    content_tag :div, class: 'truncate-abstract' do
      links = []
      args[:value].each do |val|
        link = link_to val, search_action_path({:f => { args[:field].to_sym => [val]}})
        links << link.html_safe
      end
      links.flatten.join(', ').html_safe
    end
  end

  def debug_output(args)
    if params[:explain].present?
      content_tag(:pre, Array(args[:value]).flatten.first, class: 'debug')
    end
  end

  def score_output(args)
    if params[:score].present?
      content_tag(:strong, "Score: #{Array(args[:value]).flatten.first}", class: 'debug')
    end
  end

  ##
  # @TODO: Why isn't this loading from GBL itself?
  # Determines if item view should render the sidebar static map
  # @return [Boolean]
  def render_sidebar_map?(document)
    Settings.SIDEBAR_STATIC_MAP&.any? { |vp| document.viewer_protocol == vp }
  end

  ##
  # Gets current layout for use in rendering partials
  # @return [String] item, index, home, or default
  def layout_type
    if params[:controller] == "catalog"
      if params[:action] == "show" || params[:action] == "downloads"
        "item"
      elsif params[:action] == "index"
        "index"
      end
    else
      "default"
    end
  end

  ##
  # Creates a link to a faceted search
  # @param [String] field
  # @param [String] value
  # @param [Hash] existing_params
  # @return [String] link
  def faceted_search_link(field, value, existing_params = {})
    updated_params = existing_params.merge("f[#{field}][]" => value)
    link_to value, "#{root_url}?#{updated_params.to_query}"
  end

  def year_to_facet_bucket(year)
    case year.to_i
    when 2025..Time.now.year
      '2025-present'
    when 2020..2024
      '2020-2024'
    when 2015..2019
      '2015-2019'
    when 2010..2014
      '2010-2014'
    when 2005..2009
      '2005-2009'
    when 2000..2004
      '2000-2004'
    when 1950..1999
      '1950-1999'
    when 1900..1949
      '1900-1949'
    when 1850..1899
      '1850-1899'
    when 1800..1849
      '1800-1849'
    when 1700..1799
      '1700s'
    when 1600..1699
      '1600s'
    when 1500..1599
      '1500s'
    else
      '1400s-earlier'
    end
  end

  # Create a link back to the index screen, keeping the user's facet, query and paging choices intact by using session.
  # @example
  #   link_back_to_catalog(label: 'Back to Search')
  #   link_back_to_catalog(label: 'Back to Search', route_set: my_engine)
  def btaa_link_back_to_catalog(opts = { label: nil })
    scope = opts.delete(:route_set) || self
    query_params = search_state.reset(current_search_session.try(:query_params)).to_hash

    if search_session['counter']
      per_page = (search_session['per_page'] || blacklight_config.default_per_page).to_i
      counter = search_session['counter'].to_i

      query_params[:per_page] = per_page unless search_session['per_page'].to_i == blacklight_config.default_per_page
      query_params[:page] = ((counter - 1) / per_page) + 1
    end

    link_url = if query_params.empty?
                 search_action_path(only_path: true)
               else
                 scope.url_for(query_params)
               end
    label = opts.delete(:label)

    if link_url =~ /bookmarks/
      label ||= t('blacklight.back_to_bookmarks')
    end

    label ||= t('blacklight.back_to_search')

    # Customized to just return the link_url
    link_url
  end

  def card_background_style(document)
    if thumb_to_render?(document&.kithe_model)
      "background-image: url('#{document&.kithe_model&.thumbnail&.file_url(:thumb_standard_2X)}');" \
      "background-size: cover;" \
      "background-position: center;" \
      "min-height: 200px;"
    elsif document[Settings.FIELDS.RESOURCE_CLASS]&.present?
      svg_file_path = asset_path("blacklight/#{document[Settings.FIELDS.RESOURCE_CLASS]&.first&.downcase&.tr(' ', '_')}.svg")
      "background-image: url('#{svg_file_path}');" \
      "background-size: 50% auto;" \
      "background-repeat: no-repeat;" \
      "background-position: center;" \
      "min-height: 200px;" \
      "width: 100%;" \
      "display: block !important;" \
      "overflow: hidden;"
    else
      "min-height: 200px;" \
      "width: 100%;" \
      "display: block !important;" \
      "overflow: hidden;"
    end
  end
end

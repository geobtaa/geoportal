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

    if date_string.size == 4
      date_value = date_string
    elsif date_string.match?(/[-|:|\/]/)
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
      '13'=> 'University of Nebraska-Lincoln'
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
end

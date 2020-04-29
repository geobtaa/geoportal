require 'chronic'

module ApplicationHelper
  def localized_image_path(url_hash)
    Rails.root.join("public/uploads/localized/#{url_hash}")
  end

  def remote_image_link(url)
    url_hash = Digest::MD5.hexdigest(url)
    if File.exist? localized_image_path(url_hash)
      geoportal_image_link = asset_url("uploads/localized/#{url_hash}")
    else
      external_image_link = url
      LocalizeImageJob.perform_later(url)
      external_image_link
    end
  end

  def homepage?
    current_page?(root_url) && has_search_parameters? == false
  end

  def citation_dct_issued_s(dct_issued_s)
    date_string = ""

    if dct_issued_s.size == 4
      date_string = dct_issued_s
    elsif dct_issued_s.match?(/[-|:|\/]/)
      begin
        date_string = Chronic.parse(dct_issued_s).to_date.strftime('%Y')
      rescue
        begin
          # Capture YYYY from '2004-01-00' / the '00' day value breaks Chronic
          date_string = dct_issued_s.split("-")[0]
        rescue
          date_string = dct_issued_s
        end
      end
    else
      date_string = dct_issued_s
    end

    # Guard against unknown dates
    if date_string == '9999'
      date_string = 'n.d.'
    end

    date_string
  end

  def b1g_institution_codes
    {
      '01'=> 'Indiana',
      '02'=> 'Illinois',
      '03'=> 'Iowa',
      '04'=> 'Maryland',
      '05'=> 'Minnesota',
      '06'=> 'Michigan State',
      '07'=> 'Michigan',
      '08'=> 'Purdue',
      '09'=> 'Penn State',
      '10'=> 'Wisconsin',
      '11'=> 'Ohio State',
      '12'=> 'Chicago'
    }
  end

  def b1g_access_links(document)
    links = {}
    document.access_links.each do |key,value|
      links[b1g_institution_codes[key]] = value
    end

    links.sort.to_h
  end
end

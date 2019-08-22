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
      date_string = Chronic.parse(dct_issued_s).to_date.strftime('%b %d, %Y')
    else
      date_string = dct_issued_s
    end

    date_string
  end

  def citation_solr_year_i(solr_year_i)
    date_string = ""

    if solr_year_i.to_s.include?('9999')
      date_string = "[unknown date]"
    else
      date_string = solr_year_i.to_s
    end

    date_string
  end
end

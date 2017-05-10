require 'json'

module ApplicationHelper

  def thumbnail_image_url(field)
    if field[:value].is_a?(Array)
      thumbnail_tag(field[:document], field[:value].first)
    else
      thumbnail_tag(field[:document], field[:value])
    end
  end

  def retrieve_url(val)
    json = JSON.parse(val)

    if json.has_key?('http://schema.org/thumbnailUrl')
      return json['http://schema.org/thumbnailUrl']
    else
      return false
    end
  end

  def thumbnail_tag(doc, url)
    if retrieve_url(url)
      image_tag(retrieve_url(url), alt: doc._source["title"], class: 'img img-responsive')
    else
      return false
    end
  end
end

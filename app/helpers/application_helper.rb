require 'json'

module ApplicationHelper

  def thumbnail_tag(doc)
    content_tag(:a, :href => doc.thumbnail_link, :title => "Visit original source") do
      image_tag(doc.thumbnail_image, alt: doc._source["title"], class: 'img img-responsive')
    end
  end
end

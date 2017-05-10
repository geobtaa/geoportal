require 'json'

module ApplicationHelper

  def thumbnail_tag(doc)
    image_tag(doc.thumbnail_image, alt: doc._source["title"], class: 'img img-responsive')
  end
end

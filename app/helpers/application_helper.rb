require 'json'

module ApplicationHelper

def thumbnail_image_url(document, opts)
  JSON.parse(document._source["dct_references_s"])['http://schema.org/thumbnailUrl']
end

=begin
  def thumbnail_tag(doc)
    content_tag(:a, :href => doc.thumbnail_link, :title => "Visit original") do
      image_tag(doc.thumbnail_image, alt: doc._source["title"], class: 'img img-responsive')
    end
  end
=end

end

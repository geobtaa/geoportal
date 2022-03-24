solrinst = RSolr.connect url: Blacklight.connection_config[:url]

# Select all the "published" docs from Solr
response = solrinst.get('select', params: {q: 'b1g_publication_state_s:published', fl: 'id', rows: 999999})

# Build a flat sorted array of all document slugs
slugs = response['response']['docs'].map { |doc| doc['id'] }.sort

# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = 'https://geo.btaa.org'
SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #

  slugs.each { |slug| add "/catalog/#{slug}" }
end

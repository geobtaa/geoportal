# frozen_string_literal: true

require "test_helper"

class DocumentHelperTest < ActionView::TestCase
  include DocumentHelper

  # Test for localize_link method
  test "localize_link" do
    remote_link = 'https://geodev.btaa.org/admin/api.json?q=water\u0026search_field=all_fields\u0026sort=solr_year_i+desc%2C+dc_title_sort+asc'
    local_link = localize_link(remote_link)

    assert_equal '/admin/documents?q=water\\u0026search_field=all_fields\\u0026sort=solr_year_i+desc%2C+dc_title_sort+asc', local_link
  end

  # Test for sort_link method
  test "sort_link" do
    link = {
      "attributes" => {"label" => "Relevance"},
      "links" => {"self" => "http://localhost:3000/admin/api.json?page=1&q=water&rows=20&sort=score+desc%2C+dct_title_sort+asc"}
    }
    expected_html = '<a class="dropdown-item" href="/admin/documents?page=1&amp;q=water&amp;rows=20&amp;sort=score+desc%2C+dct_title_sort+asc">Relevance</a>'
    assert_dom_equal expected_html, sort_link(link)
  end

  # Test for link_from_api - facet add link
  test "link_from_api - facet add link" do
    link = {
      "links" => {"self" => "http://localhost:3000/admin/api.json?f%5Bb1g_genre_sm%5D%5B%5D=Geospatial+data&q=water&rows=20&sort=solr_year_i+desc%2C+dc_title_sort+asc"}
    }
    agg = link_from_api(link)

    assert_equal "add", agg[:action]
    assert_equal "/admin/documents?f%5Bb1g_genre_sm%5D%5B%5D=Geospatial+data&q=water&rows=20&sort=solr_year_i+desc%2C+dc_title_sort+asc", agg[:link]
  end

  # Test for link_from_api - facet remove link
  test "link_from_api - facet remove link" do
    link = {
      "links" => {"remove" => "http://localhost:3000/admin/api.json?f%5Bb1g_genre_sm%5D%5B%5D=Geospatial+data&q=water&rows=20&sort=solr_year_i+desc%2C+dc_title_sort+asc"}
    }
    agg = link_from_api(link)

    assert_equal "remove", agg[:action]
    assert_equal "/admin/documents?f%5Bb1g_genre_sm%5D%5B%5D=Geospatial+data&q=water&rows=20&sort=solr_year_i+desc%2C+dc_title_sort+asc", agg[:link]
  end

  # Test for previous_link method
  test "previous_link" do
    links = {
      "prev" => "http://localhost:3000/admin/api.json?page=1&q=water&rows=20&sort=solr_year_i+desc%2C+dc_title_sort+asc"
    }
    expected_html = '<a class="btn btn-outline-primary btn-sm" href="/admin/documents?page=1&amp;q=water&amp;rows=20&amp;sort=solr_year_i+desc%2C+dc_title_sort+asc">Previous</a>'
    assert_dom_equal expected_html, previous_link(links)
  end

  # Test for previous_link when not present
  test "previous_link - not present" do
    links = {}
    expected_html = '<a class="btn btn-outline-primary btn-sm disabled" href="javascript:;" aria-disabled="true">Previous</a>'
    assert_dom_equal expected_html, previous_link(links)
  end

  # Test for next_link present
  test "next_link present" do
    links = {
      "next" => "http://localhost:3000/admin/api.json?page=2&q=water&rows=20&sort=solr_year_i+desc%2C+dc_title_sort+asc"
    }
    expected_html = '<a class="btn btn-outline-primary btn-sm" href="/admin/documents?page=2&amp;q=water&amp;rows=20&amp;sort=solr_year_i+desc%2C+dc_title_sort+asc">Next</a>'
    assert_dom_equal expected_html, next_link(links)
  end

  # Test for next_link not present
  test "next_link - not present" do
    links = {}
    expected_html = '<a class="btn btn-outline-primary btn-sm disabled" href="javascript:;" aria-disabled="true">Next</a>'
    assert_dom_equal expected_html, next_link(links)
  end

  # Test for blacklight_link method
  test "blacklight_link" do
    bl_link = blacklight_link(documents(:ag))

    assert_includes(bl_link, "/catalog/35c8a641589c4e13b7aa11e37f3f00a1_0")
  end

  # Test for publication_state_badge method
  test "publication_state_badge" do
    document = documents(:ag)
    document.publication_state = "draft"
    document.save

    output = publication_state_badge(document).to_s
    assert_match(/badge-secondary/, output)
    assert_match(/Draft/, output)

    document.publication_state = "published"
    output = publication_state_badge(document).to_s
    assert_match(/badge-success/, output)
    assert_match(/Published/, output)

    document.publication_state = "unpublished"
    output = publication_state_badge(document).to_s
    assert_match(/badge-danger/, output)
    assert_match(/Unpublished/, output)
  end

  # Test for thumb_to_render? method
  test "thumb_to_render? returns true when thumbnail has file url and derivatives" do
    thumbnail = OpenStruct.new(file_url: "http://example.com/thumb.jpg", file_derivatives: true)
    document = OpenStruct.new(thumbnail: thumbnail)

    assert thumb_to_render?(document)
  end

  test "thumb_to_render? returns false when thumbnail is missing file url or derivatives" do
    thumbnail = OpenStruct.new(file_url: nil, file_derivatives: nil)
    document = OpenStruct.new(thumbnail: thumbnail)

    assert_not thumb_to_render?(document)
  end
end

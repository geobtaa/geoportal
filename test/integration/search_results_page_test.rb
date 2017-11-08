require "test_helper"

class SearchResultsPageTest < Capybara::Rails::TestCase

  def setup
  end

  def test_search
    visit '/?q=water'
    assert page.has_content?("Search Results")
  end

  def test_map_clustering
    visit '/?q=water&search_field=all_fields&view=mapview'
    assert page.has_selector?("div.prunecluster.leaflet-marker-icon", :wait => 10)
  end

  def test_map_clustering_result_paging
    visit '/?page=2&q=water&search_field=all_fields&view=mapview'
    assert page.has_selector?("div.prunecluster.leaflet-marker-icon", :wait => 10)
  end

  def test_empty_search
    visit '/?search_field=all_fields&q='
    assert page.assert_selector('div.document', :count => 20)
  end

  def test_facets
    visit '/?q=water'
    assert page.has_selector?("#facets")
    assert page.assert_selector('div.facet_limit', :count => 11)
    assert page.has_content?("Institution")
    assert page.has_content?("Subject")
    assert page.has_content?("Author")
    assert page.has_content?("Place")
    assert page.has_content?("Year")
    assert page.has_content?("Time Period")
    assert page.has_content?("Access")
    assert page.has_content?("Data type")
    assert page.has_content?("Format")
  end

  def test_getBounds
    visit '/?f%5Btime_period%5D%5B%5D=1600s&per_page=10&q=asia&search_field=all_fields'
    assert page.assert_selector('div.document', :count => 10)
  end

  def test_thumbnails_docview
    visit '/?q=minnesota&search_field=all_fields&view=split'
    assert page.has_selector?("img.item-thumbnail")
  end

  def test_thumbnails_mapview
    visit '/?q=minnesota&search_field=all_fields&view=mapview'
    assert page.has_no_selector?("img.item-thumbnail")
  end

  def test_thumbnails_solr_field
    visit '/?search_field=all_fields&q=87adb12a-30b5-4bc3-866c-97adcd7e3d2e'
    assert page.has_selector?("img.item-thumbnail")
  end
end

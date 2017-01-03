require "test_helper"

class ShowPageTest < Capybara::Rails::TestCase

  def setup
    # Remote testing the show page features
    Capybara.app_host = 'https://geo.btaa.org'
  end

  def test_purdue_shapefile_show
    visit "/catalog/Purdue-urn-24bde658-53ff-41a7-9c62-15c5204a497c"
    assert page.has_content?("Bedrock Geology: Indiana, 2010")

    # Type
    click_link 'Web services'

    # WMS Web Service
    assert page.has_content?("Web Mapping Service (WMS)")
    assert page.has_selector?("#wms_webservice")

    # Esri Web Service
    assert page.has_content?("ArcGIS Dynamic Map Layer")
    assert page.has_selector?("#dynamic_map_layer_webservice")

    # ISO Metadata
    assert page.has_link?("Metadata")

    # IIIF Image
    assert page.has_no_content?("iiif")

    # Download
    assert page.has_content?("Download Shapefile")

    # Provenance
    assert page.has_content?("Purdue")
  end

  def test_wisconsin_geodatabase_show
    visit "/catalog/Wisconsin-urn-656ed665-63fc-45d9-96ab-465a07488f91"
    assert page.has_content?("Hydrography (1:24,000), Wisconsin 2015")

    # Type
    assert page.has_no_link?("Web services")

    # ISO Metadata
    assert page.has_link?("Metadata")

    # IIIF Image
    assert page.has_no_content?("iiif")

    # Download
    assert page.has_content?("Download Geodatabase")

    # Provenance
    assert page.has_content?("Wisconsin")
  end

  def test_minnesota_shapefile_show
    visit "/catalog/Minnesota-urn-480d1dc0-5fdd-42e2-b21c-7488d2496f7f"
    assert page.has_content?("Polling Places: Carver County, Minnesota, 2014")

    # Type
    click_link 'Web services'

    # WMS Web Service
    assert page.has_no_content?("Web Mapping Service (WMS)")
    assert page.has_no_selector?("#wms_webservice")

    # Esri Web Service
    assert page.has_content?("ArcGIS Dynamic Map Layer")
    assert page.has_selector?("#dynamic_map_layer_webservice")

    # ISO Metadata
    assert page.has_link?("Metadata")

    # IIIF Image
    assert page.has_no_content?("iiif")

    # Download
    assert page.has_content?("Download Shapefile")

    # Provenance
    assert page.has_content?("Minnesota")
  end

  def test_minnesota_tiff_show
    visit "/catalog/minnesota-129514e1-a6d2-404e-8d44-077adee866e2"
    assert page.has_content?("Burritt's sectional and township map of Minnesota")

    # Type
    assert page.has_no_link?("Web services")

    # WMS Web Service
    assert page.has_no_content?("Web Mapping Service (WMS)")
    assert page.has_no_selector?("#wms_webservice")

    # Esri Web Service
    assert page.has_no_content?("ArcGIS Dynamic Map Layer")
    assert page.has_no_selector?("#dynamic_map_layer_webservice")

    # ISO Metadata
    assert page.has_no_link?("Metadata")

    # IIIF Image
    assert page.has_selector?("div[data-protocol='Iiif']")

    # Download
    assert page.has_content?("Download Tiff")

    # Provenance
    assert page.has_content?("Minnesota")
  end

  def test_iowa_map_show
    visit "/catalog/iowa-urn-f1b57f24-d474-4493-90e1-d3c25f39b65b"
    assert page.has_content?("An Illustrated Historical Atlas of Des Moines County, Iowa, 1873")

    # Type
    click_link 'Web services'

    # WMS Web Service
    assert page.has_no_content?("Web Mapping Service (WMS)")
    assert page.has_no_selector?("#wms_webservice")

    # Esri Web Service
    assert page.has_content?("ArcGIS Dynamic Map Layer")
    assert page.has_selector?("#dynamic_map_layer_webservice")

    # ISO Metadata
    assert page.has_no_link?("Metadata")

    # IIIF Image
    assert page.has_no_content?("iiif")

    # Download
    assert page.has_no_content?("Download Tiff")

    # Provenance
    assert page.has_content?("Iowa")
  end
end

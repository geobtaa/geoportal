require "test_helper"

class ShowPageTest < Capybara::Rails::TestCase

  def setup
  end

  def test_purdue_shapefile_show
    visit "/catalog/24bde658-53ff-41a7-9c62-15c5204a497c"
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
    visit "/catalog/656ed665-63fc-45d9-96ab-465a07488f91"
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
    visit "/catalog/5a60ef842b9e4da5a55c0dec30c4ad8d_1"
    assert page.has_content?("Polling Places: Carver County, Minnesota")

    # Type
    click_link 'Web services'

    # WMS Web Service
    # assert page.has_no_content?("Web Mapping Service (WMS)")
    # assert page.has_no_selector?("#wms_webservice")

    # Esri Web Service
    assert page.has_content?("ArcGIS Dynamic Map Layer")
    assert page.has_selector?("#dynamic_map_layer_webservice")

    # ISO Metadata
    assert page.has_no_link?("Metadata")

    # IIIF Image
    assert page.has_no_content?("iiif")

    # Download
    assert page.has_content?("Download Shapefile")

    # Provenance
    assert page.has_content?("Minnesota")
  end

  def test_minnesota_tiff_show
    visit "/catalog/7e1d9ddf-5cc6-413d-824c-0e1e43e33c8c"
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
    visit "/catalog/f1b57f24-d474-4493-90e1-d3c25f39b65b"
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

  def test_relations_parent_record
    visit "/catalog/88cc9b19-3294-4da9-9edd-775c81fb1c59"
    assert page.has_content?("Wabash Topo (Parent Record): Indiana, 1929")

    # Data Relations
    assert page.has_content?("Data Relations")
    assert page.has_content?("Derived Datasets")
  end

  def test_relations_child_record
    visit "/catalog/02999877-0ee9-4cc0-b67f-f2f48107f517"
    assert page.has_content?("Wabash Topo (14): Indiana, 1929")

    # Data Relations
    assert page.has_content?("Data Relations")
    assert page.has_content?("Source Datasets")
  end

  # Record no longer available?
  def test_relations_none
    skip
    visit "/catalog/1a09f168-4c06-42e1-b91c-f3d4d03ad829"
    assert page.has_content?("10 Ft Contours: Carver County, Minnesota, 2014")

    # Data Relations
    assert page.has_no_content?("Data Relations")
  end
end

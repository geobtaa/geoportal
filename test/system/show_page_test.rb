require "application_system_test_case"

class ShowPageTest < ApplicationSystemTestCase
  def setup
  end

  def teardown
    # ran_without_js_errors
  end

  def test_minnesota_tiff_show
    skip('New UMedia launch has broken this test object')
    visit "/catalog/71f15b25-64cd-40cc-8f0c-64529293398c"
    assert page.has_content?("Railroad commissioners' map of Minnesota")

    # Help
    assert page.has_content?("IIIF Service")

    # Type
    assert page.has_link?("Web services")
    click_link 'Web services'

    # WMS Web Service
    assert page.has_no_content?("Web Mapping Service (WMS)")
    assert page.has_no_selector?("#wms_webservice")

    # Esri Web Service
    assert page.has_no_content?("ArcGIS Dynamic Map Layer")
    assert page.has_no_selector?("#dynamic_map_layer_webservice")

    # IIIF
    assert page.has_content?("International Image Interoperability Framework (IIIF)")

    # Type
    click_button 'Close'

    # ISO Metadata
    assert page.has_no_link?("Metadata")

    # IIIF Image
    assert page.has_selector?("div[data-protocol='Iiif']")

    # Downloads
    assert page.has_content?("Downloads")
    assert page.has_link?("Original Tiff")
    assert page.has_link?("Original JPG")

    # Provenance
    assert page.has_content?("Minnesota")
  end

  def test_illinois_open_in_arcgis
    visit "/catalog/90f14ff4-1359-4beb-b931-5cb41d20ab90"
    assert page.has_content?("Glacial Boundaries: Illinois, 1998")

    # Help
    assert page.has_content?("ArcGIS Dynamic Map Layer")

    # Type
    assert page.has_content?("Web services")

    # ISO Metadata
    assert page.has_no_link?("Metadata")

    # IIIF Image
    assert page.has_no_selector?("div[data-protocol='Iiif']")

    # Download
    assert page.has_content?("Downloads")
    assert page.has_link?("Original Shapefile")

    # Export
    assert page.has_link?("Open in ArcGIS")

    # Provenance
    assert page.has_link?("Illinois")
  end

  def test_minnesota_shapefile_show
    visit "/catalog/b98a7b39-830a-48ca-84c2-06332aaebbb8"
    assert page.has_content?("Twin Cities Land Use Map from the Twin Cities Metropolitan Planning Commission, 1958")

    # Type
    assert page.has_no_content?("Web services")

    # ISO Metadata
    assert page.has_link?("Metadata")

    # IIIF Image
    assert page.has_no_selector?("div[data-protocol='Iiif']")

    # Download
    assert page.has_content?("Downloads")
    assert page.has_link?("Original Shapefile")

    # Provenance
    assert page.has_link?("Minnesota")
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

  def test_relations_related_records
    visit "/catalog/88cc9b19-3294-4da9-9edd-775c81fb1c59"
    assert page.has_content?("Wabash River Topographic Maps: Indiana, 1929")

    # Help
    assert page.has_content?("ArcGIS Image Map Layer")

    # Metadata
    # ISO Metadata
    assert page.has_link?("Metadata")

    assert page.has_link?("Web services")

    # Data Relations
    assert page.has_content?("Related Items")
    assert page.has_content?("Related Records")
  end

  def test_relations_child_record
    visit "/catalog/02999877-0ee9-4cc0-b67f-f2f48107f517"

    # Help
    assert page.has_content?("ArcGIS Image Map Layer")

    # ISO Metadata
    assert page.has_link?("Metadata")

    # Download
    assert page.has_content?("Downloads")
    assert page.has_link?("Original GeoTIFF")

    # Data Relations
    assert page.has_content?("Related Items")
    assert page.has_content?("Parent Record")
  end

  def test_fullscreen_map_toggle
    skip('No toggle on static images for now.')
    visit "/catalog/87adb12a-30b5-4bc3-866c-97adcd7e3d2e"
    assert page.has_selector?(".leaflet-control-fullscreen-button")
    click_on(class: 'leaflet-control-fullscreen-button')
  end

  def test_sidebar_map_basemap
    visit "/catalog/f9eb8493-32ab-4ede-8330-9286846eee0d"
    assert page.has_selector?("[data-basemap=esri]")
  end

  def test_metadata_links
    visit "/catalog/2eddde2f-c222-41ca-bd07-2fd74a21f4de"
    assert page.has_link?("Minnesota Department of Natural Resources (DNR)")
    assert page.has_no_link?("Minnesota Geospatial Commons") # Collection
    assert page.has_link?("Minnesota, United States")
    assert page.has_link?("Imagery and Base Maps")
    assert page.has_link?("Dataset")
    assert page.has_link?("Minnesota")
  end

  def test_b1g_show_index_map
    visit "/catalog/9702bb22-4305-4cc2-a8f4-fc10e4ef05df"

    # Help
    assert page.has_content?("Index Map")

    within('#map') do
      assert page.has_selector?("svg.leaflet-zoom-animated")
      assert page.has_selector?("path.leaflet-interactive")
    end
  end

  def test_browse_descendants
    visit "/catalog/princeton-1r66j405w"
    # Browse Relations
    click_link("Browse all 4 records...")
    within("span.page-entries") do
      assert page.has_content?("4")
    end
  end

  def test_mirador_show_page
    visit "/catalog/62aac6a8-d31e-4364-8946-ff9bebbf4a25"

    # Help
    # assert page.has_content?("Index Map")

    assert page.has_selector?("#map")
    assert page.has_selector?("[data-protocol='IiifManifest']")

    # Sidebar Map
    within(".page-sidebar")do
      assert page.has_selector?("#static-map")
    end
  end

end

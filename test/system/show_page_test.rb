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
    assert page.has_link?("Tiff")
    assert page.has_link?("JPG")

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
    assert page.has_content?("Download")
    assert page.has_link?("Shapefile")

    # Export
    assert page.has_link?("Open in ArcGIS Online")

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
    assert page.has_content?("Download")
    assert page.has_link?("Shapefile")

    # Provenance
    assert page.has_link?("Minnesota")
  end

  def test_iowa_map_show
    visit "/catalog/f1b57f24-d474-4493-90e1-d3c25f39b65b"
    assert page.has_content?("An Illustrated Historical Atlas of Des Moines County, Iowa, 1873")

    # Type
    click_link 'Web Services'

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
    skip('Moving to dct_isPartOf_sm for relations')
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
    assert page.has_content?("Download")
    assert page.has_link?("GeoTIFF")

    # Data Relations
    # assert page.has_content?("Related Items")
    # assert page.has_content?("Parent Record")
  end

  def test_fullscreen_map_toggle
    skip('No toggle on static images for now.')
    visit "/catalog/87adb12a-30b5-4bc3-866c-97adcd7e3d2e"
    assert page.has_selector?(".leaflet-control-fullscreen-button")
    click_on(class: 'leaflet-control-fullscreen-button')
  end

  def test_sidebar_map_basemap
    visit "/catalog/f9eb8493-32ab-4ede-8330-9286846eee0d"
    assert page.has_selector?("[data-basemap=openstreetmapStandard]")
  end

  def test_metadata_links
    visit "/catalog/2eddde2f-c222-41ca-bd07-2fd74a21f4de"

    # No Links
    assert page.has_no_link?("Minnesota Department of Natural Resources (DNR)")
    assert page.has_no_link?("2015-11-18")

    # Yes Links
    assert page.has_link?("Minnesota")
    assert page.has_link?("Datasets")
    assert page.has_link?("Raster data")
    assert page.has_link?("Imagery")

    assert page.has_no_link?("Minnesota Geospatial Commons") # Collection
  end

  def test_b1g_show_index_map
    visit "/catalog/9702bb22-4305-4cc2-a8f4-fc10e4ef05df"

    # Help
    assert page.has_content?("Index Map")
    assert page.has_content?("Map held by collection")

    within('#map') do
      assert page.has_selector?("svg.leaflet-zoom-animated")
      assert page.has_selector?("path.leaflet-interactive")
    end
  end

  def test_stanford_show_index_map
    visit "/catalog/stanford-fb897vt9938"

    # Help
    assert page.has_content?("Index Map")

    within('#map') do
      assert page.has_selector?("svg.leaflet-zoom-animated")
      assert page.has_selector?("path.leaflet-interactive")
    end
  end

  def test_browse_descendants
    skip('Moving to dct_isPartOf_sm for relations')
    visit "/catalog/princeton-1r66j405w"
    # Browse Relations
    click_link("Browse all 4 records...")
    within("span.page-entries") do
      assert page.has_content?("4")
    end
  end

  def test_mirador_show_book
    visit "/catalog/62aac6a8-d31e-4364-8946-ff9bebbf4a25"

    assert page.has_selector?("#map")
    assert page.has_selector?("[data-protocol='IiifManifest']")

    # Sidebar Map
    within(".page-sidebar")do
      assert page.has_selector?("#static-map")
    end
  end

  def test_mirador_show_map
    visit "/catalog/e1ec54e6-8bb4-496a-93f9-43ac901bea74"

    assert page.has_selector?("#map")
    assert page.has_selector?("[data-protocol='IiifManifest']")

    # Sidebar Map
    within(".page-sidebar")do
      assert page.has_selector?("#static-map")
    end
  end

  def test_oembed_map
    visit "/catalog/stanford-dc482zx1528"

    assert page.has_selector?("#map")
    assert page.has_selector?("[data-protocol='Oembed']")
  end

  def test_b1g_image_map
    visit "/catalog/VAC9619-001727"

    # Help
    assert page.has_content?("Static Image")

    assert page.has_selector?("#map.b1g_image")
    assert page.has_selector?("[data-protocol='B1gImage']")
  end

  def test_collection_ancestor
    skip('Revisit relation tests in Aardvark')
    visit '/catalog/e84a24f0-1c00-4235-a584-db5d7551cbe6'

    # Data Relations
    assert page.has_content?("Collection")
  end

  def test_citation_tool
    visit '/catalog/b06d96e4-c917-4afc-a3df-adbbc9a2273c'

    # Citation
    assert page.has_text?("Cite")

    # Available from link should include slug
    assert page.has_content?("b06d96e4-c917-4afc-a3df-adbbc9a2273c")
  end

  def test_no_citation_tool_for_collections
    visit '/catalog/05d-03-noGeomType'

    # Citation
    assert page.has_no_link?("Cite")
  end

  def test_crawford_county_403_error
    visit '/catalog/d6efb1e4d0ca491db8c79e5b18c4dee9_3'
    assert page.has_no_content?("Our Apologies")
  end

  def test_item_viewer_cors_error
    skip('No longer erring - EWL')
    visit '/catalog/4669301e-b4b2-4c8b-bf40-01b968a2865b'
    assert page.has_content?("Our Apologies")
  end

  def test_item_viewer_nonsecure_error
    skip('No longer erring - EWL')
    visit '/catalog/4669301e-b4b2-4c8b-bf40-01b968a2865b'
    assert page.has_content?("Our Apologies")
  end

  def test_item_viewer_deleted_feature
    visit '/catalog/4d2053c593cc4f7685f2823f9e2061b8_1'
    assert page.has_content?("Our Apologies")
  end

  def test_access_links_restricted_document
    visit '/catalog/99-0001-test'
    within('dl.document-metadata') do
      assert page.has_content?("Rights")
    end
    within('div.page-sidebar') do
      assert page.has_content?("Licensed Resource")
      assert page.has_link?("University of Minnesota")
    end
  end

  def test_access_links_public_document
    visit '/catalog/4d2053c593cc4f7685f2823f9e2061b8_1'
    within('div.page-sidebar') do
      assert page.has_no_content?("Licensed Resource")
      assert page.has_no_link?("University of Minnesota")
    end
  end

  def test_b1g_image_sidebar_map
    visit '/catalog/VAC9619-001735'
    within('.page-sidebar') do
      assert page.has_content?("Location")
      assert page.has_selector?("#static-map")
    end
  end

  # @TODO: Not truncating currently.
  def test_b1g_description_html_link
    skip('Not truncating currently.')
    visit '/catalog/99-0011'
    within('dd.blacklight-dct_description_sm') do
      within('.truncate-abstract') do
        assert page.has_link?("https://sites.google.com/umn.edu/btaa-gdp/help/restricted-resources")
      end
    end
  end

  def test_b1g_access_rights_html_link
    visit '/catalog/99-0011-minnesota'
    assert page.has_link?("https://sites.google.com/umn.edu/btaa-gdp/help/restricted-resources")
  end

  # @TODO: Not truncating currently.
  def test_b1g_placename_readmore_link
    skip('Not truncating currently.')
    visit '/catalog/99-0011-minnesota'
    within('dd.blacklight-dct_spatial_sm') do
      assert page.has_content?("Read more")
    end
  end

  # @TODO: Redo semantic itemprops
  def test_multiline_description
    skip('itemprops not defined currently.')
    visit '/catalog/18bed919-fc86-4e02-a909-15f8bb9899bb'
    within('dd.blacklight-dct_description_sm') do
      assert page.has_selector?("span[itemprop='description']")
      assert page.has_content?("\n")
    end
  end

  def test_suppressed_child_actions_render
    visit '/catalog/b45275a9-61bd-4d5a-aa1e-ba8d6d1e26aa/citation'
    assert page.has_content?("Cite")
  end

  # @TODO
  # ESRI - Slow - ImageMapLayer
  # http://localhost:3000/catalog/457dc8bbff9b46848843c8b1bf0ae689

  # ESRI - Extremely Large
  # http://localhost:3000/catalog/ab0f0408fcb5479e97df5a13d9a3c648_0

  # ESRI - Visibility Extent
  # http://localhost:3000/catalog/458cf4b7d44543d2a3bee3bd92914af9_3
end

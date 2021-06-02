require "application_system_test_case"

class CitationTest < ApplicationSystemTestCase
  def setup
  end

  def teardown
    # ran_without_js_errors
  end

  def test_citation_tool
    visit '/catalog/b06d96e4-c917-4afc-a3df-adbbc9a2273c/citation'

    # Available from link should include slug
    assert page.has_content?("b06d96e4-c917-4afc-a3df-adbbc9a2273c")

    # Text
    assert page.has_content?("Bernardin-Lochmueller & Associates. (2004). National Sediment Inventory (NSI) and Data Summaries, Derived from EPA BASINS 3: Indiana. State of Indiana.")

    # Links
    assert page.has_link?("http://maps.indiana.edu/previewMaps/Hydrology/Water_Quality_Sediment_Inventory.html")
  end
end

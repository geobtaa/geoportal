require "application_system_test_case"

class RelationshipsTest < ApplicationSystemTestCase
  def setup
  end

  def teardown
    # ran_without_js_errors
  end

  def test_wabash_topo_browse_children_link
    # Wabash Topo parent record
    visit "/catalog/88cc9b19-3294-4da9-9edd-775c81fb1c59"

    assert page.has_content?("Has part...")
    assert page.has_link?("Browse all 4 records...")
    click_link("Browse all 4 records...")

    assert page.has_no_content?("No results found for your search")
  end

  def test_child_relationships_hide_unpublished_docs
    # Aitkin parent record
    visit "/catalog/27001-road-centerlines"
    assert page.has_content?("Aitkin County GIS")

    # Relationships should not be present
    assert page.has_no_selector?(".card.relations")
    assert page.has_no_content?("Has version...")
    assert page.has_no_link?("Road Centerlines [Aitkin County] 2021")
  end
end

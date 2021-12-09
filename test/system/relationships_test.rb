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

    assert page.has_no_text?("No results found for your search")

  end
end

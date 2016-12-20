require "test_helper"

class SearchResultsPageTest < Capybara::Rails::TestCase

  def setup
    visit "/?q=water"
  end

  def test_search
    assert page.has_content?("Search Results")
  end

  def test_facets
    assert page.has_selector?("#facets")
    assert page.has_content?("Institution")
    assert page.has_content?("Subject")
    assert page.has_content?("Author")
    assert page.has_content?("Place")
    assert page.has_content?("Year")
    assert page.has_content?("Access")
    assert page.has_content?("Data type")
    assert page.has_content?("Format")
  end
end

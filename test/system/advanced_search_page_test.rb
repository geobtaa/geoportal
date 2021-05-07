require "application_system_test_case"

class AdvancedSearchPageTest < ApplicationSystemTestCase
  def setup
    visit "/advanced"
  end

  def test_page_elements
    assert page.has_content?("Advanced Search")
    assert page.has_content?("Limit Results By")
    within("div.limit-criteria") do
      assert page.has_content?("Resource Class")
      assert page.has_content?("Resource Type")
      assert page.has_content?("Provider")
      assert page.has_content?("Year")
    end

    assert_equal page.all('select#f1 option').map(&:value), %w(keyword title placename publisher)
  end
end

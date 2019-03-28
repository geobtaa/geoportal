require "test_helper"

class AdvancedSearchTest < Capybara::Rails::TestCase

  def setup
    visit "/advanced"
  end

  def test_page_elements
    assert page.has_content?("Advanced Search")
    assert page.has_content?("Limit Results By")
    within("div.limit-criteria") do
      assert page.has_content?("Genre")
      assert page.has_content?("Institution")
      assert page.has_content?("Type")
      assert page.has_content?("Year")
    end
  end
end

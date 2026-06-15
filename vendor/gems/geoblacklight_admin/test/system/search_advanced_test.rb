# frozen_string_literal: true

require "application_system_test_case"

class SearchAdvancedTest < ApplicationSystemTestCase
  def setup
    sign_in_as users(:user_001)
  end

  test "search advanced dom" do
    visit "/admin/search"
    assert page.has_selector?("nav.navbar")
    assert page.has_selector?("#search-form")
    within("#search-form") do
      assert page.has_selector?("input[name='q']")
      assert page.has_selector?("#facet-limits")
      within("#facet-limits") do
        assert page.has_text?("Resource Class")
        assert page.has_text?("Provider")
        assert page.has_text?("Code")
        assert page.has_text?("Is Part Of")
        assert page.has_text?("Member Of")
        assert page.has_text?("Resource Type")
        assert page.has_text?("Subject")
        assert page.has_text?("Theme")
        assert page.has_text?("Format")
        # assert page.has_text?("Suppressed")
        # assert page.has_text?("Child Record")
        # assert page.has_text?("Georeferenced")
      end
    end
  end
end

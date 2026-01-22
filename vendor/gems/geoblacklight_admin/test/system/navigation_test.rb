# frozen_string_literal: true

require "application_system_test_case"

class NavigationTest < ApplicationSystemTestCase
  def setup
    sign_in_as users(:user_001)
  end

  test "visiting the index" do
    visit admin_documents_url
    within("nav.navbar") do
      assert page.has_link?("GBL♦Admin")
      assert page.has_selector?("form")
      assert page.has_selector?("input[name='q']")
      assert page.has_link?("Admin Tools")
      assert page.has_link?("Import Primary", visible: false)
      assert page.has_link?("Import Distributions", visible: false)
      assert page.has_link?("Import Licensed Accesses", visible: false)
      assert page.has_link?("Primary Imports", visible: false)
      assert page.has_link?("Distribution Imports", visible: false)
      assert page.has_link?("Distributions", visible: false)
      assert page.has_link?("Licensed Accesses", visible: false)
      assert page.has_link?("Assets", visible: false)
      assert page.has_link?("Blazer", visible: false)
      assert page.has_link?("Elements", visible: false)
      assert page.has_link?("Form Elements", visible: false)
      assert page.has_link?("Reference Types", visible: false)
      assert page.has_link?("Users", visible: false)
    end
  end
end

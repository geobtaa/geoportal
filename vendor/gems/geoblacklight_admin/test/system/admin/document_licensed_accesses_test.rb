# frozen_string_literal: true

require "application_system_test_case"

module Admin
  class DocumentLicensedAccessesTest < ApplicationSystemTestCase
    include Devise::Test::IntegrationHelpers

    setup do
      @admin = users(:user_001)
      sign_in @admin
      @document = documents(:ag)
      @document_licensed_access = document_licensed_accesses(:one)
    end

    test "visiting the index" do
      visit admin_document_document_licensed_accesses_url(@document)
      assert_selector "h1", text: "Document · Licensed Access"
    end

    test "creating a Document Licensed Access" do
      visit new_admin_document_document_licensed_access_path(@document)

      find("#document_licensed_access_institution_code").find("option[value='02']").select_option
      fill_in "Licensed Access URL", with: "https://example.com"
      click_on "Create Licensed Access"

      assert_text "Document licensed access was successfully created"
    end

    test "updating a Document Licensed Access" do
      visit edit_admin_document_document_licensed_access_path(@document, @document_licensed_access)

      find("#document_licensed_access_institution_code").find("option[value='02']").select_option
      fill_in "Licensed Access URL", with: "https://updated-example.com"
      click_on "Update Licensed Access"

      assert_text "Document licensed access was successfully updated"
    end

    test "destroying a Document Licensed Access" do
      visit admin_document_licensed_accesses_url

      page.accept_confirm do
        click_on "Destroy", match: :first
      end

      assert_text "Document licensed access was successfully destroyed."
    end
  end
end

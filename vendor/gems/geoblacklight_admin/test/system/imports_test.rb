# frozen_string_literal: true

require "application_system_test_case"

class ImportsTest < ApplicationSystemTestCase
  setup do
    sign_in_as users(:user_001)
    @import = imports(:one)
  end

  test "visiting the index" do
    visit admin_imports_url
    assert_selector "h1", text: "Primary Imports"
  end

  test "creating a Import" do
    skip("@TODO: attach_file not working")

    visit admin_imports_url
    click_on "New Import"

    fill_in "Name", with: @import.name
    fill_in "Source", with: @import.source
    fill_in "Description", with: @import.description

    attach_file("import_csv_file", Rails.root.join("test/fixtures/files/btaa_formatted_records.csv"))

    select "BTAA CSV", from: "import_type"

    click_on "Create Import"

    assert_text "Import was successful. Please set your import mapping rules."
  end

  test "updating a Import" do
    skip("@TODO: attach_file not working")

    visit admin_imports_url
    click_on "Edit", match: :prefer_exact

    fill_in "Name", with: @import.name
    fill_in "Source", with: @import.source
    fill_in "Description", with: @import.description

    attach_file("import_btaa_csv_file", Rails.root.join("test/fixtures/files/btaa_formatted_records.csv"))

    click_on "Update Import btaa"

    assert_text "Import was successfully updated"
    click_on "Back"
  end

  test "destroying a Import" do
    visit admin_imports_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Import was successfully destroyed"
  end

  test "Import CSV and Export CSV match" do
    skip("Rewrite for ExportJob service")
    visit admin_imports_url
    click_on "New Import"
    fill_in "Name", with: @import.name
    fill_in "Source", with: @import.source
    fill_in "Description", with: @import.description
    attach_file("import_csv_file", Rails.root.join("test/fixtures/files/schema_support.csv"))
    select "BTAA CSV", from: "import_type"

    # Create Import
    click_on "Create Import"

    sleep(5)

    # Create Mapping
    click_on "Create Mapping"
    assert_text "Import was successfully updated."

    sleep(5)

    # Run Import!
    click_on "Run Import"
    assert_text "Import is running. Check back soon for results."

    sleep(10)

    # Download CSV
    visit "/documents/slug.csv"

    # Assert Import CSV file and Export CSV file match
    import_csv = File.read(Rails.root.join("test/fixtures/files/schema_support.csv"))
    export_csv = File.read(Rails.root.join("tmp/downloads/documents-#{Time.zone.today}.csv"))
    assert_equal(import_csv, export_csv)
  end
end

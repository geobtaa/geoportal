require "application_system_test_case"

class ElementsTest < ApplicationSystemTestCase
  setup do
    sign_in_as users(:user_001)
    @element = Element.find_by(solr_field: "dct_title_s")
  end

  test "visiting the index" do
    visit admin_elements_url
    assert_selector "h1", text: "Elements"
  end

  test "creating a Element" do
    visit admin_elements_url
    click_on "New Element"

    @element = Element.new

    fill_in "Controlled vocabulary", with: "LC"
    fill_in "Data entry hint", with: "LC Subject Heading"
    check "Display only on persisted"
    fill_in "Export transformation method", with: "transform_export_to_lcsh"
    check "Exportable"
    fill_in "Field definition", with: "LC Subject Heading"
    select "string", from: "Field type"
    check "Formable"
    fill_in "Html attributes", with: "{class: 'form-control'}"
    check "Import deliminated"
    fill_in "Import transformation method", with: "transform_import_from_lcsh"
    check "Importable"
    fill_in "Index transformation method", with: "transform_index_to_lcsh"
    check "Indexable"
    fill_in "Js behaviors", with: "autocomplete"
    fill_in "Label", with: "LCSH Heading"
    fill_in "Placeholder text", with: "Search for a subject heading"
    check "Repeatable"
    check "Required"
    fill_in "Solr field", with: "b1g_lcsh_subject_sm"
    fill_in "Test fixture example", with: "Minnesota"
    fill_in "Validation method", with: "validate_lcsh"
    click_on "Create Element"

    assert_text "Element was successfully created"
    click_on "Back"
  end

  test "updating a Element" do
    visit admin_elements_url
    click_on "Edit", match: :first

    fill_in "Controlled vocabulary", with: @element.controlled_vocabulary
    fill_in "Data entry hint", with: @element.data_entry_hint
    check "Display only on persisted" if @element.display_only_on_persisted
    fill_in "Export transformation method", with: @element.export_transformation_method
    check "Exportable" if @element.exportable
    fill_in "Field definition", with: @element.field_definition
    select @element.field_type, from: "Field type"
    check "Formable" if @element.formable
    fill_in "Html attributes", with: @element.html_attributes
    check "Import deliminated" if @element.import_deliminated
    fill_in "Import transformation method", with: @element.import_transformation_method
    check "Importable" if @element.importable
    fill_in "Index transformation method", with: @element.index_transformation_method
    check "Indexable" if @element.indexable
    fill_in "Js behaviors", with: @element.js_behaviors
    fill_in "Label", with: @element.label
    fill_in "Placeholder text", with: @element.placeholder_text
    check "Repeatable" if @element.repeatable
    check "Required" if @element.required
    fill_in "Solr field", with: @element.solr_field
    fill_in "Test fixture example", with: @element.test_fixture_example
    fill_in "Validation method", with: @element.validation_method
    click_on "Update Element"

    assert_text "Element was successfully updated"
    click_on "Back"
  end

  test "destroying a Element" do
    visit admin_elements_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Element was successfully destroyed"
  end
end

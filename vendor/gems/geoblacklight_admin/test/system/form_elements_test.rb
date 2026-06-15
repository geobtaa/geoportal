require "application_system_test_case"

class FormElementsTest < ApplicationSystemTestCase
  setup do
    sign_in_as users(:user_001)
  end

  test "visiting the index" do
    visit admin_form_elements_url
    assert_selector "h1", text: "Form Elements"
  end

  test "creating a Form element" do
    visit admin_form_elements_url
    click_on "New Form Element", match: :first

    fill_in "Label", with: "Header Label 1"
    click_on "Create Form element"

    assert_text "Form element was successfully created"
  end

  test "updating a Form element" do
    visit admin_form_elements_url
    click_on "Edit", match: :first

    fill_in "Label", with: "Header Label 2"
    click_on "Update Form element"

    assert_text "Form element was successfully updated"
    click_on "Back"
  end

  test "destroying a Form element" do
    visit admin_form_elements_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Form element was successfully destroyed"
  end
end

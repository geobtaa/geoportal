# frozen_string_literal: true

require "application_system_test_case"

class DocumentFormTest < ApplicationSystemTestCase
  def setup
    sign_in_as users(:user_001)
  end

  def test_basic_dom
    visit "/admin/documents/new"

    assert page.has_selector?("nav.navbar") # User Nav
    assert page.has_selector?("form#new_document") # Form
    assert page.has_selector?("div.admin-header") # Form Header
    assert page.has_selector?("div.form-actions") # Form Actions
    assert page.has_selector?("#form-fields") # Form Fields
    assert page.has_selector?("#form-navigation") # Form Navigation
  end

  def test_edit_action
    visit "/admin/documents/35c8a641589c4e13b7aa11e37f3f00a1_0/edit"
    assert page.has_selector?("input#document_title")
    assert page.has_selector?("span.create_bookmark")
  end

  def test_form_elements
    visit "/admin/documents/new"
    within("form#new_document") do
      # title / dct_title_s
      assert page.has_selector?("input#document_title")
      # dct_alternative_sm
      assert page.has_selector?("input#document_dct_alternative_sm_attributes_", visible: false)
      # dct_description_sm
      assert page.has_selector?("input#document_dct_alternative_sm_attributes_", visible: false)
      # dc_language_sm
      assert page.has_selector?("input#document_dct_language_sm_attributes_", visible: false)

      # b1g_genre_sm
      # assert page.has_selector?('input#document_b1g_genre_sm_attributes_', visible: false)

      # dc_type_sm
      # assert page.has_selector?('input#document_dc_type_sm_attributes_', visible: false)

      # document_dc_format_s
      assert page.has_selector?("input#document_dct_format_s[data-scihist-qa-autocomplete]")

      # dct_accrualPeriodicity_s
      assert page.has_selector?("select#document_b1g_dct_accrualPeriodicity_s")
    end
  end
end

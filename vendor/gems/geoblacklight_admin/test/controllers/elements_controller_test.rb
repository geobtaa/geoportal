# frozen_string_literal: true

require "test_helper"

class ElementsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @element = Element.find_by(solr_field: "dct_title_s")
    get "/users/sign_in"
    sign_in_as users(:user_001)
    post user_session_url

    follow_redirect!
    assert_response :success
  end

  test "should get index" do
    get admin_elements_url
    assert_response :success
    assert_not_nil assigns(:elements)
  end

  test "should get new" do
    get new_admin_element_url
    assert_response :success
  end

  test "should create element" do
    assert_difference("Element.count") do
      @element.solr_field = "new_solr_field_sm"
      @element.label = "New Solr Field Label"
      post admin_elements_url, params: {element: {controlled_vocabulary: @element.controlled_vocabulary, data_entry_hint: @element.data_entry_hint, display_only_on_persisted: @element.display_only_on_persisted, export_transformation_method: @element.export_transformation_method, exportable: @element.exportable, field_definition: @element.field_definition, field_type: @element.field_type, formable: @element.formable, html_attributes: @element.html_attributes, import_deliminated: @element.import_deliminated, import_transformation_method: @element.import_transformation_method, importable: @element.importable, index_transformation_method: @element.index_transformation_method, indexable: @element.indexable, js_behaviors: @element.js_behaviors, label: @element.label, placeholder_text: @element.placeholder_text, repeatable: @element.repeatable, required: @element.required, solr_field: "new_solr_field", test_fixture_example: @element.test_fixture_example, validation_method: @element.validation_method}}
    end

    assert_redirected_to admin_element_url(Element.last)
    follow_redirect!
    assert_select "div", text: "Element was successfully created."
  end

  test "should show element" do
    get admin_element_url(@element)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_element_url(@element)
    assert_response :success
  end

  test "should update element" do
    patch admin_element_url(@element), params: {element: {label: "Updated Label"}}
    assert_redirected_to admin_element_url(@element)
    follow_redirect!
    assert_select "div", text: "Element was successfully updated."
    @element.reload
    assert_equal "Updated Label", @element.label
  end

  test "should not update element with invalid data" do
    patch admin_element_url(@element), params: {element: {solr_field: ""}}
    assert_response :unprocessable_entity
  end

  test "should destroy element" do
    assert_difference("Element.count", -1) do
      delete admin_element_url(@element)
    end

    assert_redirected_to admin_elements_url
    follow_redirect!
    assert_select "div", text: "Element was successfully destroyed."
  end

  test "should sort elements" do
    element_1 = Element.first # Original order
    element_2 = Element.second

    id_list = [element_2.id, element_1.id] # New desired order

    post sort_admin_form_elements_url, params: {id_list: id_list}
    assert_response :success

    assert_equal id_list, Element.where(id: id_list).order(position: :desc).pluck(:id)
  end

  test "should handle invalid sort parameters gracefully" do
    put sort_admin_form_elements_url, params: {id_list: [nil, "invalid_id"]}
    assert_response :redirect
  end
end

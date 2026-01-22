# frozen_string_literal: true

require "test_helper"

module Admin
  class DocumentDataDictionaryEntriesControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

    setup do
      @document = documents(:ag)
      @document_data_dictionary = document_data_dictionaries(:one)
      @document_data_dictionary_entry = document_data_dictionary_entries(:one)

      get "/users/sign_in"
      sign_in_as users(:user_001)
      post user_session_url

      follow_redirect!
      assert_response :success
    end

    test "should get new" do
      get new_admin_document_document_data_dictionary_document_data_dictionary_entry_url(
        @document,
        @document_data_dictionary
      )
      assert_response :success
    end

    test "should create document_data_dictionary_entry" do
      assert_difference("DocumentDataDictionaryEntry.count") do
        post admin_document_document_data_dictionary_document_data_dictionary_entries_url(
          @document,
          @document_data_dictionary
        ), params: {
          document_data_dictionary_entry: {
            document_data_dictionary_id: @document_data_dictionary.id,
            friendlier_id: @document.friendlier_id,
            field_name: "test_field",
            field_type: "string",
            values: "test_values",
            definition: "Test definition"
          }
        }
      end

      assert_redirected_to admin_document_document_data_dictionary_path(@document, @document_data_dictionary)
    end

    test "should get edit" do
      get edit_admin_document_document_data_dictionary_document_data_dictionary_entry_url(
        @document,
        @document_data_dictionary,
        @document_data_dictionary_entry
      )
      assert_response :success
    end

    test "should update document_data_dictionary_entry" do
      patch admin_document_document_data_dictionary_document_data_dictionary_entry_url(
        @document,
        @document_data_dictionary,
        @document_data_dictionary_entry
      ), params: {
        document_data_dictionary_entry: {
          friendlier_id: @document.friendlier_id,
          field_name: "updated_field",
          field_type: "string",
          values: "updated_values"
        }
      }
      assert_redirected_to admin_document_document_data_dictionary_path(@document, @document_data_dictionary)
    end

    test "should destroy document_data_dictionary_entry" do
      assert_difference("DocumentDataDictionaryEntry.count", -1) do
        delete admin_document_document_data_dictionary_document_data_dictionary_entry_url(
          @document,
          @document_data_dictionary,
          @document_data_dictionary_entry
        )
      end

      assert_redirected_to admin_document_document_data_dictionary_path(@document, @document_data_dictionary)
    end

    test "should destroy all entries" do
      assert_difference("DocumentDataDictionaryEntry.count", -DocumentDataDictionaryEntry.count) do
        post destroy_all_admin_document_document_data_dictionary_document_data_dictionary_entries_path(
          @document,
          @document_data_dictionary
        )
      end

      assert_redirected_to admin_document_document_data_dictionary_document_data_dictionary_entries_path(
        @document_data_dictionary.friendlier_id,
        @document_data_dictionary
      )
    end

    test "should sort entries" do
      entry1 = document_data_dictionary_entries(:one)
      entry2 = document_data_dictionary_entries(:two)

      post sort_admin_document_document_data_dictionary_document_data_dictionary_entries_url(
        @document,
        @document_data_dictionary
      ), params: {id_list: [entry2.id, entry1.id]}

      assert_response :success
    end
  end
end

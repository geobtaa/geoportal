require "test_helper"

class DocumentDataDictionariesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @document = documents(:ag)
    @document_data_dictionary = document_data_dictionaries(:one)

    # Load CSV fixture as a Rack::Test::UploadedFile
    @file = Rack::Test::UploadedFile.new(
      Rails.root.join("test/fixtures/files/btaa_sample_document_data_dictionary_entries.csv"),
      "text/csv"
    )

    # Simulate sign-in
    get "/users/sign_in"
    sign_in_as users(:user_001)
    post user_session_url
    follow_redirect!
    assert_response :success
  end

  test "should get index" do
    get admin_document_document_data_dictionaries_url(@document)
    assert_response :success
  end

  test "should get new" do
    get new_admin_document_document_data_dictionary_url(@document)
    assert_response :success
  end

  test "should create document_data_dictionary" do
    skip("file upload missing in test runner")
    assert_difference("DocumentDataDictionary.count") do
      post admin_document_document_data_dictionaries_url(@document),
        params: {
          document_data_dictionary: {
            friendlier_id: "35c8a641589c4e13b7aa11e37f3f00a1_0",
            name: "Created Dictionary",
            description: "Created Description",
            staff_notes: "Created Staff Notes",
            tags: "tag1,tag2,tag3",
            # Make sure this key (csv_file) matches what the controller expects
            csv_file: @file
          }
        },
        as: :multipart_form  # <-- Ensures the request is sent as multipart
    end

    assert_redirected_to admin_document_document_data_dictionaries_url(@document)
  end

  test "should show document_data_dictionary" do
    get admin_document_document_data_dictionary_url(@document, @document_data_dictionary)
    assert_response :success
  end

  test "should show document data dictionary in CSV format" do
    get admin_document_document_data_dictionary_url(@document, @document_data_dictionary, format: :csv)
    assert_response :success
    assert_equal "text/csv; charset=utf-8", @response.content_type
  end

  test "should get edit" do
    get edit_admin_document_document_data_dictionary_url(@document, @document_data_dictionary)
    assert_response :success
  end

  test "should update document_data_dictionary" do
    skip("file upload missing in test runner")
    patch admin_document_document_data_dictionary_url(@document, @document_data_dictionary),
      params: {
        document_data_dictionary: {
          friendlier_id: "35c8a641589c4e13b7aa11e37f3f00a1_0",
          name: "Updated Dictionary",
          description: "Updated Description",
          staff_notes: "Updated Staff Notes",
          tags: "tag1,tag2,tag3",
          csv_file: @file
        }
      },
      as: :multipart_form  # <-- multipart for file update
    assert_redirected_to admin_document_document_data_dictionaries_url(@document)
  end

  test "should destroy document_data_dictionary" do
    assert_difference("DocumentDataDictionary.count", -1) do
      delete admin_document_document_data_dictionary_url(@document, @document_data_dictionary)
    end

    assert_redirected_to admin_document_document_data_dictionaries_url(@document)
  end
end

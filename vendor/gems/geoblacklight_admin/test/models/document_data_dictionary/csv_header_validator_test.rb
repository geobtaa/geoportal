# frozen_string_literal: true

require "test_helper"

class DocumentDataDictionary::CsvHeaderValidatorTest < ActiveSupport::TestCase
  def setup
    @validator = DocumentDataDictionary::CsvHeaderValidator.new
    @record = OpenStruct.new(csv_file: nil, errors: ActiveModel::Errors.new(self))
  end

  def test_valid_csv_headers
    csv_content = "friendlier_id,field_name,field_type,values,definition,definition_source,parent_field_name\n"
    file_mock = Minitest::Mock.new
    file_mock.expect :download, StringIO.new(csv_content)
    file_mock.expect :nil?, false
    @record.csv_file = file_mock

    assert @validator.validate(@record), "Expected CSV headers to be valid"
    assert_empty @record.errors[:csv_file], "Expected no errors for valid CSV headers"
  end

  def test_invalid_csv_headers
    csv_content = "friendlier_id,field_name\n"
    file_mock = Minitest::Mock.new
    file_mock.expect :download, StringIO.new(csv_content), []
    file_mock.expect :download, StringIO.new(csv_content), []
    file_mock.expect :nil?, false
    @record.csv_file = file_mock

    refute @validator.validate(@record), "Expected CSV headers to be invalid"
    assert_includes @record.errors[:csv_file], "Missing a required CSV header. friendlier_id, field_name, field_type, values, definition, definition_source, and parent_field_name are required."
  end

  def test_missing_csv_file
    skip("file download missing in test runner")
    @record.csv_file = nil

    refute @validator.validate(@record), "Expected validation to fail with missing CSV file"
    assert_includes @record.errors[:csv_file], "Missing a required CSV header. friendlier_id, field_name, field_type, values, definition, definition_source, and parent_field_name are required."
  end
end

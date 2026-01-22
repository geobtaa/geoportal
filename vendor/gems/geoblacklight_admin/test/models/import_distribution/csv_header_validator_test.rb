# frozen_string_literal: true

require "test_helper"

class ImportDistribution::CsvHeaderValidatorTest < ActiveSupport::TestCase
  def setup
    @validator = ImportDistribution::CsvHeaderValidator.new
    @record = OpenStruct.new(csv_file: nil, errors: ActiveModel::Errors.new(self))
  end

  def test_valid_csv_headers
    csv_content = "friendlier_id,reference_type,distribution_url,label\n"
    file_mock = Minitest::Mock.new
    file_mock.expect :download, StringIO.new(csv_content)
    file_mock.expect :nil?, false
    @record.csv_file = file_mock

    assert @validator.validate(@record), "Expected CSV headers to be valid"
    assert_empty @record.errors[:csv_file], "Expected no errors for valid CSV headers"
  end

  def test_invalid_csv_headers
    csv_content = "friendlier_id,reference_type\n"
    file_mock = Minitest::Mock.new
    file_mock.expect :download, StringIO.new(csv_content)
    file_mock.expect :nil?, false
    @record.csv_file = file_mock

    refute @validator.validate(@record), "Expected CSV headers to be invalid"
    assert_includes @record.errors[:csv_file], "Missing a required CSV header. friendlier_id, reference_type, distribution_url, and label are required."
  end

  def test_missing_csv_file
    @record.csv_file = nil

    refute @validator.validate(@record), "Expected validation to fail with missing CSV file"
    assert_includes @record.errors[:csv_file], "Missing a required CSV header. friendlier_id, reference_type, distribution_url, and label are required."
  end
end

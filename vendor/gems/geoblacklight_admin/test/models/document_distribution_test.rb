require "test_helper"

class DocumentDistributionTest < ActiveSupport::TestCase
  def setup
    @document_distribution = DocumentDistribution.new(
      friendlier_id: documents(:ls).friendlier_id,
      reference_type_id: ReferenceType.first.id,
      url: "http://example.com",
      label: "Example Label"
    )
  end

  test "should be valid" do
    assert @document_distribution.valid?
  end

  test "friendlier_id should be present" do
    @document_distribution.friendlier_id = nil
    assert_not @document_distribution.valid?
  end

  test "reference_type should be present" do
    @document_distribution.reference_type = nil
    assert_not @document_distribution.valid?
  end

  test "url should be present" do
    @document_distribution.url = nil
    assert_not @document_distribution.valid?
  end

  test "url should be unique scoped to friendlier_id and reference_type_id" do
    duplicate_distribution = @document_distribution.dup
    @document_distribution.save
    assert_not duplicate_distribution.valid?
  end

  test "should convert to CSV" do
    expected_csv = [
      @document_distribution.friendlier_id,
      @document_distribution.reference_type.name,
      @document_distribution.url,
      @document_distribution.label
    ]
    assert_equal expected_csv, @document_distribution.to_csv
  end

  test "should convert to aardvark distribution" do
    expected_aardvark = {
      @document_distribution.reference_type.reference_uri.to_s => @document_distribution.url
    }
    expected_aardvark[:label] = @document_distribution.label if @document_distribution.reference_type.reference_uri.to_s == "http://schema.org/downloadUrl"
    assert_equal expected_aardvark, @document_distribution.to_aardvark_distribution
  end

  test "should destroy all from CSV" do
    file_path = File.expand_path("../../../test/fixtures/files/import_distributions.csv", __FILE__)
    file = File.open(file_path)
    DocumentDistribution.import(file)
    assert_difference "DocumentDistribution.count", -3 do
      DocumentDistribution.destroy_all(file)
    end
  end

  test "should reindex document after save" do
    document = documents(:ag)
    @document_distribution.document = document
    @document_distribution.save
    assert document.saved_changes?
  end

  # Add more tests for edge cases and other methods as needed
end

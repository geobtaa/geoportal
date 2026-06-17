# test/models/document_bbox_validator_test.rb
require "test_helper"

class DocumentBboxValidatorTest < ActiveSupport::TestCase
  def setup
    @document = documents(:ag)
  end

  test "validates a proper W,S,E,N bbox" do
    @document.dcat_bbox = "-96.6391,40.3754,-90.1401,43.5012"

    validator = Document::BboxValidator.new
    valid = validator.validate(@document)

    assert valid, "Expected W,S,E,N bbox to be valid"
  end

  test "rejects bbox with max longitude below boundary" do
    @document.dcat_bbox = "-98.0,47.733333,-971.0,48.5"

    validator = Document::BboxValidator.new
    valid = validator.validate(@document)

    assert_not valid, "Expected out-of-range max longitude to be invalid"
    assert_includes @document.errors["dcat_bbox"].join, "invalid maxX present"
  end

  test "rejects zero-width bbox" do
    @document.dcat_bbox = "11.077,60.790,11.077,60.791"

    validator = Document::BboxValidator.new
    valid = validator.validate(@document)

    assert_not valid, "Expected zero-width bbox to be invalid"
    assert_includes @document.errors["dcat_bbox"].join, "maxX must be greater than minX"
  end

  test "rejects non-numeric bbox coordinates" do
    @document.dcat_bbox = "-98.0,47.733333,nope,48.5"

    validator = Document::BboxValidator.new
    valid = validator.validate(@document)

    assert_not valid, "Expected non-numeric bbox to be invalid"
    assert_includes @document.errors["dcat_bbox"].join, "invalid W,S,E,N syntax"
  end

  test "rejects non-finite bbox coordinates" do
    @document.dcat_bbox = "-98.0,47.733333,NaN,48.5"

    validator = Document::BboxValidator.new
    valid = validator.validate(@document)

    assert_not valid, "Expected non-finite bbox to be invalid"
    assert_includes @document.errors["dcat_bbox"].join, "invalid W,S,E,N syntax"
  end
end

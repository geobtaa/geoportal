# test/models/document_geom_validator_test.rb
require "test_helper"

class DocumentGeomValidatorTest < ActiveSupport::TestCase
  def setup
    @document = documents(:ag)
  end

  test "validates a proper ENVELOPE" do
    @document.locn_geometry = "ENVELOPE(-180,180,90,-90)"

    validator = Document::GeomValidator.new
    valid = validator.validate(@document)

    assert valid, "Expected ENVELOPE to be valid"
  end

  test "rejects invalid ENVELOPE with multiple periods" do
    @document.locn_geometry = "ENVELOPE(-180.00.0000,180,90,-90)"

    validator = Document::GeomValidator.new
    valid = validator.validate(@document)

    assert_not valid, "Expected ENVELOPE with multiple periods to be invalid"
    assert_includes @document.errors["locn_geometry"].join, "invalid ENVELOPE(W,E,N,S) syntax - found multiple periods in coordinate value(s)."
  end

  test "rejects an improper POLYGON" do
    @document.locn_geometry = "POLYGON((-180 90, 180 90, 180 -90, -180 -90, -180 90))"

    validator = Document::GeomValidator.new
    valid = validator.validate(@document)

    assert_not valid, "Expected world-wide POLYGON to be invalid"
    assert_includes @document.errors["locn_geometry"].join, "Invalid polygon: all points are coplanar input, Solr will not index"
  end

  test "validates a proper MULTIPOLYGON" do
    @document.locn_geometry = "MULTIPOLYGON(((-180 90, 180 90, 180 -90, -180 -90, -180 90)))"

    validator = Document::GeomValidator.new
    valid = validator.validate(@document)

    assert valid, "Expected MULTIPOLYGON to be valid"
  end

  test "rejects invalid POLYGON" do
    @document.locn_geometry = "POLYGON((-180 90, 180 90, 180 -90, -180 -90, -180 90)"

    validator = Document::GeomValidator.new
    valid = validator.validate(@document)

    assert_not valid, "Expected invalid POLYGON to be rejected"
    assert_includes @document.errors["locn_geometry"].join, "Invalid geometry"
  end

  test "rejects coplanar points" do
    @document.locn_geometry = "POLYGON((-180.0 90.0, 180.0 90.0, 180.0 -90.0, -180.0 -90.0, -180.0 90.0))"

    validator = Document::GeomValidator.new
    valid = validator.validate(@document)

    assert_not valid, "Expected coplanar points to be rejected"
    assert_includes @document.errors["locn_geometry"].join, "Invalid polygon: all points are coplanar input, Solr will not index"
  end
end

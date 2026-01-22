# frozen_string_literal: true

require "test_helper"
require "active_model"

class ImportBtaaTest < ActiveSupport::TestCase
  setup do
    @import_btaa = ImportBtaa.new
  end

  test "mapping_configuration returns importable fields" do
    expected_fields = GeoblacklightAdmin::Schema.instance.importable_fields
    assert_equal expected_fields, @import_btaa.mapping_configuration
  end

  test "klass_delimiter returns correct delimiter" do
    assert_equal "|", @import_btaa.klass_delimiter
  end

  test "default_mappings returns correct hard value mappings" do
    expected_mappings = [{gbl_mdVersion_s: "Aardvark"}]
    assert_equal expected_mappings, @import_btaa.default_mappings
  end

  test "assumed_mappings returns an empty array" do
    assert_empty @import_btaa.assumed_mappings
  end

  test "derived_mappings returns correct derived mappings" do
    expected_mappings = [
      {dcat_centroid: {field: "dcat_bbox", method: "derive_dcat_centroid"}},
      {gbl_georeferenced_b: {field: "gbl_georeferenced_b", method: "derive_boolean"}},
      {gbl_suppressed_b: {field: "gbl_suppressed_b", method: "derive_boolean"}}
    ]
    assert_equal expected_mappings, @import_btaa.derived_mappings
  end

  test "required_mappings returns an empty array" do
    assert_empty @import_btaa.required_mappings
  end

  test "derive_dcat_centroid calculates centroid from bbox" do
    data_hash = {"dcat_bbox" => "10,20,30,40"} # w, s, e, n
    args = {data_hash: data_hash, field: "dcat_bbox"}
    expected_centroid = "30.0,20.0" # calculated as ((n + s) / 2, (e + w) / 2)

    assert_equal expected_centroid, @import_btaa.derive_dcat_centroid(args)
  end

  test "derive_dcat_centroid returns nil if bbox is blank" do
    data_hash = {"dcat_bbox" => ""}
    args = {data_hash: data_hash, field: "dcat_bbox"}

    assert_nil @import_btaa.derive_dcat_centroid(args)
  end

  test "derive_boolean correctly casts truthy values" do
    data_hash = {"gbl_georeferenced_b" => "true"}
    args = {data_hash: data_hash, field: "gbl_georeferenced_b"}

    assert_equal true, @import_btaa.derive_boolean(args)
  end

  test "derive_boolean correctly casts falsy values" do
    data_hash = {"gbl_georeferenced_b" => "false"}
    args = {data_hash: data_hash, field: "gbl_georeferenced_b"}

    assert_equal false, @import_btaa.derive_boolean(args)
  end

  test "derive_boolean returns false if field is blank" do
    data_hash = {"gbl_georeferenced_b" => ""}
    args = {data_hash: data_hash, field: "gbl_georeferenced_b"}

    assert_equal false, @import_btaa.derive_boolean(args)
  end
end

# frozen_string_literal: true

require "test_helper"

class ImportBtaaAardvarkTest < ActiveSupport::TestCase
  setup do
    @import_btaa_aardvark = ImportBtaaAardvark.new
  end

  test "mapping_configuration returns field mappings for BTAA Aardvark" do
    expected_mappings = GeoblacklightAdmin::Schema.instance.importable_fields
    assert_equal expected_mappings, @import_btaa_aardvark.mapping_configuration
  end

  test "klass_delimiter returns correct delimiter" do
    assert_equal "|", @import_btaa_aardvark.klass_delimiter
  end

  test "default_mappings returns correct hard value mappings" do
    expected_mappings = [{gbl_mdVersion_s: "Aardvark"}]
    assert_equal expected_mappings, @import_btaa_aardvark.default_mappings
  end

  test "assumed_mappings returns an empty array" do
    assert_empty @import_btaa_aardvark.assumed_mappings
  end

  test "derived_mappings returns correct derived mappings" do
    expected_mappings = [
      {dct_references_s: {field: "dct_references_s", method: "geomg_dct_references_s"}},
      {gbl_dateRange_drsim: {field: "gbl_dateRange_drsim", method: "geomg_b1g_date_range_drsim"}},
      {locn_geometry: {field: "locn_geometry", method: "solr_geom_mapping"}}
    ]
    assert_equal expected_mappings, @import_btaa_aardvark.derived_mappings
  end

  test "required_mappings returns an empty array" do
    assert_empty @import_btaa_aardvark.required_mappings
  end

  test "solr_geom_mapping correctly formats the geometry string" do
    data_hash = {"locn_geometry" => "ENVELOPE(-87\\, -85.76\\, 39.78\\, 37.96)"}
    args = {data_hash: data_hash, field: "locn_geometry"}
    expected_result = "-87, 37.96, -85.76, 39.78"

    assert_equal expected_result, @import_btaa_aardvark.solr_geom_mapping(args)
  end

  test "solr_geom_mapping returns an empty string when geometry is blank" do
    data_hash = {"locn_geometry" => ""}
    args = {data_hash: data_hash, field: "locn_geometry"}

    assert_equal "", @import_btaa_aardvark.solr_geom_mapping(args)
  end

  test "geomg_b1g_date_range_drsim formats date range correctly" do
    data_hash = {"gbl_dateRange_drsim" => ["[2020 TO 2020]"]}
    args = {data_hash: data_hash, field: "gbl_dateRange_drsim"}
    expected_result = "2020-2020"

    assert_equal expected_result, @import_btaa_aardvark.geomg_b1g_date_range_drsim(args)
  end

  test "geomg_b1g_date_range_drsim handles empty date range" do
    data_hash = {"gbl_dateRange_drsim" => []}
    args = {data_hash: data_hash, field: "gbl_dateRange_drsim"}

    assert_nil @import_btaa_aardvark.geomg_b1g_date_range_drsim(args)
  end

  test "geomg_dct_references_s parses references correctly" do
    data_hash = {"dct_references_s" => [{value: '{"http://www.opengis.net/def/serviceType/ogc/wms":"http://example.com/wms"}'}]}
    args = {data_hash: data_hash, field: "dct_references_s"}
    expected_result = [
      {
        value: "http://example.com/wms",
        category: GeoblacklightAdmin::FieldMappingsBtaaAardvark.uri_2_category_references_mappings["http://www.opengis.net/def/serviceType/ogc/wms"]
      }
    ]

    assert_equal expected_result, @import_btaa_aardvark.geomg_dct_references_s(args)
  end

  test "geomg_dct_references_s returns empty array if field is empty" do
    data_hash = {"dct_references_s" => []}
    args = {data_hash: data_hash, field: "dct_references_s"}

    assert_empty @import_btaa_aardvark.geomg_dct_references_s(args)
  end
end

require "test_helper"

class ImportGblv1Test < ActiveSupport::TestCase
  def setup
    @import = ImportGblv1.new
  end

  def test_mapping_configuration
    assert_equal GeoblacklightAdmin::Schema.instance.importable_fields, @import.mapping_configuration
  end

  def test_klass_delimiter
    assert_equal "|", @import.klass_delimiter
  end

  def test_default_mappings
    expected = [{geoblacklight_version: "1.0"}]
    assert_equal expected, @import.default_mappings
  end

  def test_assumed_mappings
    assert_equal [], @import.assumed_mappings
  end

  def test_derived_mappings
    expected = [
      {dct_references_s: {field: "dct_references_s", method: "geomg_dct_references_s"}},
      {b1g_date_range_drsim: {field: "b1g_date_range_drsim", method: "geomg_b1g_date_range_drsim"}}
    ]
    assert_equal expected, @import.derived_mappings
  end

  def test_required_mappings
    assert_empty @import.required_mappings
  end

  def test_solr_geom_mapping
    geom = "ENVELOPE(-87\\, -85.76\\, 39.78\\, 37.96)"
    expected = "ENVELOPE(-87, -85.76, 39.78, 37.96)"
    assert_equal expected, @import.solr_geom_mapping(geom)
  end

  def test_geomg_b1g_date_range_drsim
    args = {data_hash: {"date_field" => ["[2020 TO 2020]"]}, field: "date_field"}
    expected = "2020-2020"
    assert_equal expected, @import.geomg_b1g_date_range_drsim(args)
  end

  def test_geomg_dct_references_s
    json_data = {"http://www.opengis.net/def/serviceType/ogc/wms" => "http://example.com/wms"}.to_json
    args = {data_hash: {"dct_references_s" => [{value: json_data}]}, field: "dct_references_s"}
    expected = [{value: "http://example.com/wms", category: GeoblacklightAdmin::FieldMappingsGblv1.uri_2_category_references_mappings["http://www.opengis.net/def/serviceType/ogc/wms"]}]
    assert_equal expected, @import.geomg_dct_references_s(args)
  end
end

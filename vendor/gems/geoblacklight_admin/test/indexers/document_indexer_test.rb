# frozen_string_literal: true

require "test_helper"

class DocumentIndexerTest < ActiveSupport::TestCase
  setup do
    @document = documents(:ag)
  end

  test "indexes" do
    output_hash = DocumentIndexer.new.map_record(@document)

    assert(output_hash).present?
    # Kithe
    assert_equal output_hash["model_pk_ssi"], [@document.id]

    # GeoBlacklight
    assert_equal output_hash["gbl_mdVersion_s"], ["Aardvark"]

    # Form
    # Identification
    # - Descriptive
    assert_equal output_hash[GeoblacklightAdmin::Schema.instance.solr_fields[:title]], ["Agricultural Districts: Iowa"]
    assert_equal output_hash[GeoblacklightAdmin::Schema.instance.solr_fields[:alternative_title]], ["Ag Districts"]
    assert_equal output_hash[GeoblacklightAdmin::Schema.instance.solr_fields[:description]], ["Iowa Agricultural Districts"]
    assert_equal output_hash[GeoblacklightAdmin::Schema.instance.solr_fields[:language]], ["eng"]
    assert_equal output_hash[GeoblacklightAdmin::Schema.instance.solr_fields[:b1g_language]], ["English"]

    # - Credits
    assert_equal output_hash[GeoblacklightAdmin::Schema.instance.solr_fields[:creator]], ["Legislative Services Agency"]
    assert_equal output_hash[GeoblacklightAdmin::Schema.instance.solr_fields[:publisher]], ["State of Iowa"]

    # - Categories
    assert_equal output_hash[GeoblacklightAdmin::Schema.instance.solr_fields[:resource_class]], ["Datasets"]
    assert_equal output_hash[GeoblacklightAdmin::Schema.instance.solr_fields[:subject]], ["Boundaries"]
    assert_equal output_hash[GeoblacklightAdmin::Schema.instance.solr_fields[:keyword]], %w[iowa judicial districts boundaries]

    # - Temporal
    assert_equal output_hash[GeoblacklightAdmin::Schema.instance.solr_fields[:date_issued]], ["2015-09-03"]
    assert_equal output_hash[GeoblacklightAdmin::Schema.instance.solr_fields[:temporal_coverage]], ["2015"]
    assert_equal output_hash[GeoblacklightAdmin::Schema.instance.solr_fields[:date_range]], ["[2015 TO 2015]"]
    assert_equal output_hash[GeoblacklightAdmin::Schema.instance.solr_fields[:index_year]], ["2015"]

    # - Spatial
    assert_equal output_hash[GeoblacklightAdmin::Schema.instance.solr_fields[:spatial_coverage]], ["Iowa"]
    assert_nil output_hash[GeoblacklightAdmin::Schema.instance.solr_fields[:geonames]]
    assert_equal output_hash[GeoblacklightAdmin::Schema.instance.solr_fields[:geometry]], ["POLYGON((-80 25, -65 18, -64 33, -80 25))"]
    assert_equal output_hash[GeoblacklightAdmin::Schema.instance.solr_fields[:bounding_box]], ["ENVELOPE(-96.6391,-90.1401,43.5012,40.3754)"]
    assert_equal output_hash[GeoblacklightAdmin::Schema.instance.solr_fields[:centroid]], ["41.9383,-93.3896"]

    # Distribution
    # - Object
    assert_equal output_hash[GeoblacklightAdmin::Schema.instance.solr_fields[:resource_type]], ["Vector"]
    assert_equal output_hash[GeoblacklightAdmin::Schema.instance.solr_fields[:format]], ["Shapefile"]

    # - Access Links
    # - Geospatial Web Services
    # - Images
    # - Metadata

    # @TODO: assert stringified JSON
    # assert_equal output_hash['dct_references_s'], ['{\"http://schema.org/url\":\"https://lib.msu.edu/branches/map/AfJPEGs/494a-b_ae55e6v2_l/\",\"http://schema.org/downloadUrl\":\"https://archive.lib.msu.edu/maps/MSU-Scanned/Africa/494a-b_ae55e6v2_l.jpg\"}']

    assert_nil output_hash[GeoblacklightAdmin::Schema.instance.solr_fields[:b1g_image_url]]

    # Administrative
    # - Codes
    assert_equal output_hash[GeoblacklightAdmin::Schema.instance.solr_fields[:identifier]], ["35c8a641589c4e13b7aa11e37f3f00a1_0"]
    assert_equal output_hash[GeoblacklightAdmin::Schema.instance.solr_fields[:id]], ["35c8a641589c4e13b7aa11e37f3f00a1_0"]
    assert_equal output_hash[GeoblacklightAdmin::Schema.instance.solr_fields[:provider]], ["Iowa"]
    assert_equal output_hash[GeoblacklightAdmin::Schema.instance.solr_fields[:code]], ["03a-04"]

    # - Status
    assert_equal output_hash[GeoblacklightAdmin::Schema.instance.solr_fields[:status]], ["Active"]
    assert_equal output_hash[GeoblacklightAdmin::Schema.instance.solr_fields[:accrual_method]], ["ArcGIS Hub"]
    assert_nil output_hash[GeoblacklightAdmin::Schema.instance.solr_fields[:accrual_periodicity]]
    assert_equal output_hash[GeoblacklightAdmin::Schema.instance.solr_fields[:date_accessioned]], ["2020-04-24"]
    assert_nil output_hash[GeoblacklightAdmin::Schema.instance.solr_fields[:date_retired]]
    assert_equal output_hash["b1g_publication_state_s"], ["published"]

    # - Accessibility
    assert_equal output_hash[GeoblacklightAdmin::Schema.instance.solr_fields[:access_rights]], ["Public"]
    assert_equal output_hash[GeoblacklightAdmin::Schema.instance.solr_fields[:suppressed_record]], [false]
    assert_equal output_hash[GeoblacklightAdmin::Schema.instance.solr_fields[:child_record]], [false]
  end
end

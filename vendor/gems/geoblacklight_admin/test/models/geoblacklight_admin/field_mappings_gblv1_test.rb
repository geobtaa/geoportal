require "test_helper"

module GeoblacklightAdmin
  class FieldMappingsGblv1Test < ActiveSupport::TestCase
    def setup
      @field_mappings = FieldMappingsGblv1.call
      @uri_mappings = FieldMappingsGblv1.uri_2_category_references_mappings
    end

    def test_field_mappings_call
      assert @field_mappings.is_a?(Hash)
      assert @field_mappings.key?(:dc_title_s)
      assert_equal @field_mappings[:dc_title_s][:destination], GeoblacklightAdmin::Schema.instance.solr_fields[:title]
    end

    def test_uri_2_category_references_mappings
      assert @uri_mappings.is_a?(ActiveSupport::HashWithIndifferentAccess)
      assert_equal @uri_mappings["http://www.opengis.net/def/serviceType/ogc/wcs"], "wcs"
      assert_equal @uri_mappings["http://iiif.io/api/image"], "iiif_image"
    end
  end
end

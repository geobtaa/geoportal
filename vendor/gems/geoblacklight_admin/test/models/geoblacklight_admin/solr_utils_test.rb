require "test_helper"

class SolrUtilsTest < ActiveSupport::TestCase
  def setup
    @solr_url = Blacklight.connection_config[:url]
    @solr_utils = GeoblacklightAdmin::SolrUtils
  end

  def test_solr_orphan_geomg_ids
    assert_respond_to @solr_utils, :solr_orphan_geomg_ids
  end

  def test_delete_solr_orphans
    assert_respond_to @solr_utils, :delete_solr_orphans
  end
end

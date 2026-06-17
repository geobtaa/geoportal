require 'test_helper'

class KitheToResourcesBridgeTest < ActiveSupport::TestCase
  TEST_IDS = %w[
    bridge-direct-relations
    bridge-related-source
    bridge-related-target
    bridge-replaced-old
    bridge-replaced-new
    bridge-explicit-old
    bridge-explicit-new
  ].freeze

  setup do
    cleanup_test_documents
  end

  teardown do
    cleanup_test_documents
  end

  test "exports stored relation fields" do
    insert_document(
      "bridge-direct-relations",
      {
        "dct_relation_sm" => ["bridge-related-target"],
        "pcdm_memberOf_sm" => ["collection-record"],
        "dct_isPartOf_sm" => ["parent-record"],
        "dct_source_sm" => ["source-record"],
        "dct_isVersionOf_sm" => ["version-record"],
        "dct_replaces_sm" => ["deprecated-record"],
        "dct_isReplacedBy_sm" => ["replacement-record"]
      }
    )
    refresh_bridge_view

    row = KitheToResourcesBridge.find("bridge-direct-relations")

    assert_equal ["bridge-related-target"], row.dct_relation_sm
    assert_equal ["collection-record"], row.pcdm_memberOf_sm
    assert_equal ["parent-record"], row.dct_isPartOf_sm
    assert_equal ["source-record"], row.dct_source_sm
    assert_equal ["version-record"], row.dct_isVersionOf_sm
    assert_equal ["deprecated-record"], row.dct_replaces_sm
    assert_equal ["replacement-record"], row.dct_isReplacedBy_sm
  end

  test "exports symmetric relation values from either side" do
    insert_document(
      "bridge-related-source",
      { "dct_relation_sm" => ["bridge-related-target"] }
    )
    insert_document("bridge-related-target")
    refresh_bridge_view

    source = KitheToResourcesBridge.find("bridge-related-source")
    target = KitheToResourcesBridge.find("bridge-related-target")

    assert_equal ["bridge-related-target"], source.dct_relation_sm
    assert_equal ["bridge-related-source"], target.dct_relation_sm
  end

  test "exports replacement inverses into the matching Aardvark fields" do
    insert_document("bridge-replaced-old")
    insert_document(
      "bridge-replaced-new",
      { "dct_replaces_sm" => ["bridge-replaced-old"] }
    )
    insert_document(
      "bridge-explicit-old",
      { "dct_isReplacedBy_sm" => ["bridge-explicit-new"] }
    )
    insert_document("bridge-explicit-new")
    refresh_bridge_view

    old_row = KitheToResourcesBridge.find("bridge-replaced-old")
    new_row = KitheToResourcesBridge.find("bridge-replaced-new")
    explicit_old_row = KitheToResourcesBridge.find("bridge-explicit-old")
    explicit_new_row = KitheToResourcesBridge.find("bridge-explicit-new")

    assert_equal ["bridge-replaced-new"], old_row.dct_isReplacedBy_sm
    assert_equal ["bridge-replaced-old"], new_row.dct_replaces_sm
    assert_equal ["bridge-explicit-new"], explicit_old_row.dct_isReplacedBy_sm
    assert_equal ["bridge-explicit-old"], explicit_new_row.dct_replaces_sm
  end

  private

  def insert_document(friendlier_id, json_attributes = {})
    quoted_id = connection.quote(friendlier_id)
    quoted_title = connection.quote("Bridge Test #{friendlier_id}")
    quoted_json = connection.quote(json_attributes.to_json)

    connection.execute(<<~SQL.squish)
      INSERT INTO kithe_models (
        title,
        type,
        json_attributes,
        created_at,
        updated_at,
        friendlier_id,
        kithe_model_type,
        publication_state
      )
      VALUES (
        #{quoted_title},
        'Document',
        #{quoted_json}::jsonb,
        CURRENT_TIMESTAMP,
        CURRENT_TIMESTAMP,
        #{quoted_id},
        1,
        'published'
      )
    SQL
  end

  def cleanup_test_documents
    quoted_ids = TEST_IDS.map { |id| connection.quote(id) }.join(", ")
    connection.execute("DELETE FROM kithe_models WHERE friendlier_id IN (#{quoted_ids})")
    refresh_bridge_view if bridge_view_exists?
  end

  def refresh_bridge_view
    connection.execute("REFRESH MATERIALIZED VIEW kithe_to_resources_bridge")
  end

  def bridge_view_exists?
    connection.select_value(<<~SQL.squish)
      SELECT to_regclass('kithe_to_resources_bridge') IS NOT NULL
    SQL
  end

  def connection
    ActiveRecord::Base.connection
  end
end

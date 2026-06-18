require "test_helper"
require Rails.root.join("db/migrate/20260618120000_reconcile_placeheld_thumbnail_assets").to_s

class ThumbnailAssetStateTest < ActiveSupport::TestCase
  include ActiveSupport::Testing::TimeHelpers

  DOCUMENT_FRIENDLIER_ID = "thumb-placeheld-bridge-test"
  ASSET_FRIENDLIER_ID = "thumb-placeheld-bridge-test-asset"
  ORIGINAL_TIME = Time.zone.parse("2025-01-01 00:00:00 UTC")
  CHANGE_TIME = Time.zone.parse("2026-06-18 17:00:00 UTC")

  setup do
    cleanup_test_records
  end

  teardown do
    cleanup_test_records
  end

  test "thumbnail asset repairs placeheld state and marks bridge row updated" do
    document = insert_document
    asset = insert_asset(document)

    document.thumbnail_state_machine.transition_to!(:processing, {"solr_doc_id" => document.friendlier_id})
    document.thumbnail_state_machine.transition_to!(:placeheld, {"solr_doc_id" => document.friendlier_id})

    assert_equal "placeheld", document.thumbnail_state_machine.current_state

    refresh_bridge_view
    assert_in_delta ORIGINAL_TIME.to_f, KitheToResourcesBridge.find(DOCUMENT_FRIENDLIER_ID).kithe_updated_at.to_f, 1

    travel_to CHANGE_TIME do
      asset.update!(thumbnail: true)
    end

    document.reload
    document.instance_variable_set(:@thumbnail_state_machine, nil)

    assert_equal "succeeded", document.thumbnail_state_machine.current_state
    assert_equal "asset_thumbnail_sync", document.thumbnail_state_machine.last_transition.metadata["source"]
    assert_equal asset.id, document.thumbnail_state_machine.last_transition.metadata["asset_id"]
    assert_equal CHANGE_TIME.utc.iso8601, document.json_attributes["date_modified_dtsi"]
    assert_in_delta CHANGE_TIME.to_f, document.updated_at.to_f, 1

    refresh_bridge_view
    assert_in_delta CHANGE_TIME.to_f, KitheToResourcesBridge.find(DOCUMENT_FRIENDLIER_ID).kithe_updated_at.to_f, 1
  end

  test "reconciliation touches repaired documents for bridge sync" do
    document = insert_document
    insert_asset(document, thumbnail: true)

    document.thumbnail_state_machine.transition_to!(:processing, {"solr_doc_id" => document.friendlier_id})
    document.thumbnail_state_machine.transition_to!(:placeheld, {"solr_doc_id" => document.friendlier_id})

    refresh_bridge_view
    assert_equal "placeheld", document.thumbnail_state_machine.current_state
    assert_in_delta ORIGINAL_TIME.to_f, KitheToResourcesBridge.find(DOCUMENT_FRIENDLIER_ID).kithe_updated_at.to_f, 1

    travel_to CHANGE_TIME do
      ActiveRecord::Migration.suppress_messages do
        ReconcilePlaceheldThumbnailAssets.new.up
      end
    end

    document.reload
    document.instance_variable_set(:@thumbnail_state_machine, nil)

    assert_equal "succeeded", document.thumbnail_state_machine.current_state
    assert_equal "reconcile_placeheld_thumbnail_assets", document.thumbnail_state_machine.last_transition.metadata["source"]
    assert_equal CHANGE_TIME.utc.iso8601, document.json_attributes["date_modified_dtsi"]
    assert_in_delta CHANGE_TIME.to_f, document.updated_at.to_f, 1
    assert_in_delta CHANGE_TIME.to_f, KitheToResourcesBridge.find(DOCUMENT_FRIENDLIER_ID).kithe_updated_at.to_f, 1
  end

  private

  def insert_document
    json_attributes = {
      "geomg_id_s" => DOCUMENT_FRIENDLIER_ID,
      "dct_accessRights_s" => "Public",
      "gbl_resourceClass_sm" => ["Datasets"]
    }

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
        #{connection.quote("Thumbnail Bridge Test")},
        'Document',
        #{connection.quote(json_attributes.to_json)}::jsonb,
        #{connection.quote(ORIGINAL_TIME)},
        #{connection.quote(ORIGINAL_TIME)},
        #{connection.quote(DOCUMENT_FRIENDLIER_ID)},
        1,
        'published'
      )
    SQL

    Document.find_by!(friendlier_id: DOCUMENT_FRIENDLIER_ID)
  end

  def insert_asset(document, thumbnail: false)
    json_attributes = {
      "thumbnail" => thumbnail,
      "derivative_storage_type" => "public"
    }
    file_data = {
      "id" => "asset/test-thumbnail.png",
      "storage" => "store",
      "metadata" => {
        "filename" => "test-thumbnail.png",
        "size" => 1234,
        "mime_type" => "image/png"
      }
    }

    connection.execute(<<~SQL.squish)
      INSERT INTO kithe_models (
        title,
        type,
        position,
        json_attributes,
        created_at,
        updated_at,
        parent_id,
        friendlier_id,
        file_data,
        kithe_model_type,
        publication_state
      )
      VALUES (
        #{connection.quote("Thumbnail Asset")},
        'Asset',
        1,
        #{connection.quote(json_attributes.to_json)}::jsonb,
        #{connection.quote(ORIGINAL_TIME)},
        #{connection.quote(ORIGINAL_TIME)},
        #{connection.quote(document.id)},
        #{connection.quote(ASSET_FRIENDLIER_ID)},
        #{connection.quote(file_data.to_json)}::jsonb,
        2,
        'draft'
      )
    SQL

    Asset.find_by!(friendlier_id: ASSET_FRIENDLIER_ID)
  end

  def cleanup_test_records
    ids = [DOCUMENT_FRIENDLIER_ID, ASSET_FRIENDLIER_ID].map { |id| connection.quote(id) }.join(", ")

    connection.execute(<<~SQL.squish)
      DELETE FROM document_thumbnail_transitions
      WHERE kithe_model_id IN (
        SELECT id FROM kithe_models WHERE friendlier_id IN (#{ids})
      )
    SQL
    connection.execute("DELETE FROM kithe_models WHERE friendlier_id IN (#{ids})")
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

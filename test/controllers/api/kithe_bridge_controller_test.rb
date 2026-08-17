require "test_helper"

class Api::KitheBridgeControllerTest < ActionDispatch::IntegrationTest
  include ActiveSupport::Testing::TimeHelpers

  DOCUMENT_IDS = %w[bridge-delta-a bridge-delta-b].freeze
  PARENT_TIME = Time.zone.parse("2026-06-30 21:16:37 -0500")
  ADDITION_TIME = Time.zone.parse("2026-07-01 08:48:14 -0500")
  DELETION_TIME = Time.zone.parse("2026-07-01 10:00:00 -0500")

  setup do
    @original_bridge_token = ENV["KITHE_BRIDGE_TOKEN"]
    ENV["KITHE_BRIDGE_TOKEN"] = "bridge-test-token"
    cleanup_test_records
    @reference_type = ReferenceType.create!(
      name: "Bridge test WMS",
      reference_type: "bridge-test-wms",
      reference_uri: "http://www.opengis.net/def/serviceType/ogc/wms"
    )
  end

  teardown do
    cleanup_test_records
    @reference_type&.destroy!
    ENV["KITHE_BRIDGE_TOKEN"] = @original_bridge_token
  end

  test "changed_since includes a delayed nested distribution addition" do
    document = insert_document(DOCUMENT_IDS.first)

    travel_to ADDITION_TIME do
      create_distribution(document)
    end

    preserve_old_parent_timestamp(document)
    refresh_bridge_view

    payload = fetch_delta(changed_since: PARENT_TIME + 1.minute)
    exported = payload.fetch("data").find { |row| row.fetch("id") == document.friendlier_id }

    assert exported
    assert_equal ["https://maps.example.edu/wms"],
      exported.fetch("document_distributions").pluck("url")
    assert_operator Time.zone.parse(exported.fetch("kithe_updated_at")), :>=, ADDITION_TIME
  end

  test "changed_since includes a resource after a nested distribution deletion" do
    document = insert_document(DOCUMENT_IDS.first)
    distribution = travel_to(ADDITION_TIME) do
      create_distribution(document)
    end

    travel_to(DELETION_TIME) { distribution.destroy! }

    preserve_old_parent_timestamp(document)
    refresh_bridge_view

    payload = fetch_delta(changed_since: ADDITION_TIME + 1.minute)
    exported = payload.fetch("data").find { |row| row.fetch("id") == document.friendlier_id }

    assert exported
    assert_empty exported.fetch("document_distributions")
    assert_operator Time.zone.parse(exported.fetch("kithe_updated_at")), :>=, DELETION_TIME
  end

  test "changed_since pagination retains id cursor ordering" do
    DOCUMENT_IDS.each do |friendlier_id|
      document = insert_document(friendlier_id)
      travel_to(ADDITION_TIME) { KitheBridgeChangeCapture.touch_parent_document!(document) }
      preserve_old_parent_timestamp(document)
    end
    refresh_bridge_view

    first_page = fetch_delta(changed_since: PARENT_TIME + 1.minute, limit: 1)
    second_page = fetch_delta(
      changed_since: PARENT_TIME + 1.minute,
      limit: 1,
      cursor: first_page.fetch("next_cursor")
    )

    assert_equal [DOCUMENT_IDS.first], first_page.fetch("data").pluck("id")
    assert first_page.fetch("has_more")
    assert_equal [DOCUMENT_IDS.second], second_page.fetch("data").pluck("id")
    refute second_page.fetch("has_more")
  end

  private

  def insert_document(friendlier_id)
    connection.execute(<<~SQL.squish)
      INSERT INTO kithe_models (
        title, type, json_attributes, created_at, updated_at,
        friendlier_id, kithe_model_type, publication_state
      )
      VALUES (
        #{connection.quote("Bridge Delta Test")},
        'Document',
        #{connection.quote({"geomg_id_s" => friendlier_id}.to_json)}::jsonb,
        #{connection.quote(PARENT_TIME)},
        #{connection.quote(PARENT_TIME)},
        #{connection.quote(friendlier_id)},
        1,
        'published'
      )
    SQL

    Document.find_by!(friendlier_id: friendlier_id)
  end

  def preserve_old_parent_timestamp(document)
    document.reload.update_column(:updated_at, PARENT_TIME)
  end

  def create_distribution(document)
    distribution = DocumentDistribution.new(
      friendlier_id: document.friendlier_id,
      reference_type: @reference_type,
      url: "https://maps.example.edu/wms"
    )
    # This focused test database does not seed Element-defined Document fields.
    # Avoid the unrelated reindex save while retaining the Bridge callbacks.
    distribution.define_singleton_method(:reindex_document) {}
    distribution.save!
    distribution
  end

  def fetch_delta(changed_since:, limit: 5000, cursor: nil)
    get api_kithe_bridge_path,
      params: {changed_since: changed_since.iso8601, limit: limit, cursor: cursor}.compact,
      headers: {"X-Bridge-Token" => "bridge-test-token"}

    assert_response :success
    JSON.parse(response.body)
  end

  def cleanup_test_records
    quoted_ids = DOCUMENT_IDS.map { |id| connection.quote(id) }.join(", ")
    connection.execute("DELETE FROM document_distributions WHERE friendlier_id IN (#{quoted_ids})")
    connection.execute("DELETE FROM kithe_models WHERE friendlier_id IN (#{quoted_ids})")
    refresh_bridge_view if bridge_view_exists?
  end

  def refresh_bridge_view
    connection.execute("REFRESH MATERIALIZED VIEW kithe_to_resources_bridge")
  end

  def bridge_view_exists?
    connection.select_value("SELECT to_regclass('kithe_to_resources_bridge') IS NOT NULL")
  end

  def connection
    ActiveRecord::Base.connection
  end
end

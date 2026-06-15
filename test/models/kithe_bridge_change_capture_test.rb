require 'test_helper'

class KitheBridgeChangeCaptureTest < ActiveSupport::TestCase
  include ActiveSupport::Testing::TimeHelpers

  FakeDocument = Struct.new(
    :friendlier_id,
    :id,
    :title,
    :import_id,
    :publication_state,
    :json_attributes,
    keyword_init: true
  )

  test "captures hard-deleted documents as tombstones" do
    document = FakeDocument.new(
      friendlier_id: "bridge-doc-1",
      id: "00000000-0000-0000-0000-000000000001",
      title: "Bridge doc",
      import_id: 42,
      publication_state: "published",
      json_attributes: {"geomg_id_s" => "geomg-123"}
    )

    captured = nil

    travel_to Time.zone.parse("2026-04-10 09:15:00 UTC") do
      with_class_method_stub(
        KitheBridgeDeletion,
        :upsert,
        ->(attrs, unique_by:) { captured = [attrs, unique_by] }
      ) do
        KitheBridgeChangeCapture.capture_document_deletion!(document)
      end
    end

    attrs, unique_by = captured

    assert_equal "bridge-doc-1", attrs[:friendlier_id]
    assert_equal "00000000-0000-0000-0000-000000000001", attrs[:kithe_model_id]
    assert_equal "Bridge doc", attrs[:title]
    assert_equal 42, attrs[:import_id]
    assert_equal "published", attrs[:publication_state]
    assert_equal "geomg-123", attrs[:geomg_id_s]
    assert_equal Time.zone.parse("2026-04-10 09:15:00 UTC"), attrs[:deleted_at]
    assert_equal :index_kithe_bridge_deletions_on_friendlier_id, unique_by
  end

  test "skips deletion capture without a friendlier id" do
    document = FakeDocument.new(
      friendlier_id: nil,
      id: "00000000-0000-0000-0000-000000000001",
      title: "Bridge doc",
      import_id: 42,
      publication_state: "published",
      json_attributes: {}
    )

    called = false

    with_class_method_stub(
      KitheBridgeDeletion,
      :upsert,
      ->(*) { called = true }
    ) do
      KitheBridgeChangeCapture.capture_document_deletion!(document)
    end

    refute called
  end

  private

  def with_class_method_stub(klass, method_name, replacement)
    singleton = class << klass; self; end
    original_defined = singleton.method_defined?(method_name) || singleton.private_method_defined?(method_name)
    original = klass.method(method_name) if original_defined

    singleton.send(:define_method, method_name) do |*args, **kwargs, &block|
      replacement.call(*args, **kwargs, &block)
    end

    yield
  ensure
    if original_defined
      singleton.send(:define_method, method_name, original)
    else
      singleton.send(:remove_method, method_name)
    end
  end
end

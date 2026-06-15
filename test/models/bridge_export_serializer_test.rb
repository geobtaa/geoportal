require 'test_helper'

class BridgeExportSerializerTest < ActiveSupport::TestCase
  FakeBridgeRow = Struct.new(:id, :deleted, :attributes, keyword_init: true)

  test "returns tombstones without loading a live document" do
    row = FakeBridgeRow.new(
      id: "bridge-doc-1",
      deleted: true,
      attributes: {
        "id" => "bridge-doc-1",
        "deleted" => true,
        "deleted_at" => "2026-04-10T00:00:00Z"
      }
    )

    with_class_method_stub(
      Document,
      :find_by,
      ->(*) { raise "deleted rows should not query Document" }
    ) do
      payload = BridgeExportSerializer.new(row).as_json

      assert_equal true, payload["deleted"]
      assert_equal [], payload["document_data_dictionaries"]
      assert_equal [], payload["document_data_dictionary_entries"]
      assert_equal [], payload["document_distributions"]
      assert_equal [], payload["document_downloads"]
      assert_equal [], payload["document_licensed_accesses"]
      assert_equal [], payload["assets"]
    end
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

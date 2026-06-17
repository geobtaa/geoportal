# frozen_string_literal: true

require "test_helper"

class DocumentIndexerTest < ActiveSupport::TestCase
  SourceRecord = Struct.new(:friendlier_id, :id, :geomg_id_s, :publication_state)

  test "includes document identifiers in traject record inspection" do
    source_record = SourceRecord.new(
      "rails-friendly-id",
      "8d90e212-0f1a-49e0-a0f2-6c8fb7f2a9e2",
      "solr-geomg-id",
      "published"
    )

    context = Traject::Indexer::Context.new(
      source_record: source_record,
      source_record_id_proc: DocumentIndexer.new.source_record_id_proc,
      output_hash: {"id" => "solr-output-id"}
    )

    record_inspect = context.record_inspect

    assert_includes record_inspect, "source_id:Document.friendlier_id=rails-friendly-id"
    assert_includes record_inspect, "Document.id=8d90e212-0f1a-49e0-a0f2-6c8fb7f2a9e2"
    assert_includes record_inspect, "geomg_id_s=solr-geomg-id"
    assert_includes record_inspect, "publication_state=published"
    assert_includes record_inspect, "output_id:solr-output-id"
  end
end

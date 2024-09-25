require 'test_helper'

class ExportTableauServiceTest < ActiveSupport::TestCase
  setup do
    @document1 = Struct.new(:title, :geomg_id_s).new(
      title: "Document 1",
      geomg_id_s: "doc1"
    )

    @document2 = Struct.new(:title, :geomg_id_s).new(
      title: "Document 2",
      geomg_id_s: "doc2"
    )
  end

  test "call method returns correct CSV data" do
    result = ExportTableauService.call

    expected_header = [
      "Title",
      "Provider",
      "Resource Class",
      "Resource Type",
      "Index Year",
      "Spatial Coverage",
      "B1G Image",
      "ID",
      "Download",
      "Language"
    ]

    assert_equal expected_header, result[0]
    assert_includes result, ["Document 1", nil, nil, nil, nil, nil, nil, "doc1", nil, nil]
    assert_includes result, ["Document 2", nil, nil, nil, nil, nil, nil, "doc2", nil, nil]
  end

  test "call method broadcasts progress" do
    broadcasts = []
    
    ActionCable.server.define_singleton_method(:broadcast) do |channel, message|
      broadcasts << [channel, message]
    end

    debugger

    # 1
    ExportTableauService.call
    # 2
    ExportTableauService.call
    # 3
    ExportTableauService.call

    debugger

    assert_equal 3, broadcasts.size
    assert_equal ["export_channel", {progress: 0}], broadcasts.first
  ensure
    ActionCable.server.singleton_class.remove_method(:broadcast) if ActionCable.server.singleton_class.method_defined?(:broadcast)
  end
end
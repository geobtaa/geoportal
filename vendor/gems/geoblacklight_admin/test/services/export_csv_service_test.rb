require "test_helper"

class ExportCsvServiceTest < ActiveSupport::TestCase
  def setup
    @document_ids = [documents(:ag).friendlier_id, documents(:ls).friendlier_id]
  end

  test "short_name returns 'Documents'" do
    assert_equal "Primary", ExportCsvService.short_name
  end

  test "call generates CSV and broadcasts progress" do
    # Capture the broadcast calls
    broadcasts = []
    ActionCable.server.stub(:broadcast, ->(channel, message) { broadcasts << {channel: channel, message: message} }) do
      csv = ExportCsvService.call(@document_ids)

      assert_not_empty csv
      assert_equal @document_ids.size + 1, csv.size # +1 for headers

      # Check the broadcasts
      assert broadcasts.any? { |b| b[:channel] == "export_channel" && b[:message] == {progress: 0} }
      assert broadcasts.size >= 1
    end
  end
end

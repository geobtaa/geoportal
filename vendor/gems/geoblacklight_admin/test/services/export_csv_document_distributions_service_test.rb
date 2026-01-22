require "test_helper"

class ExportCsvDocumentDistributionsServiceTest < ActiveSupport::TestCase
  def setup
    @document1 = Document.create!(geomg_id_s: "doc1", friendlier_id: "doc1", title: "Document 1", gbl_resourceClass_sm: ["Map"], dct_accessRights_s: "Public")
    @document2 = Document.create!(geomg_id_s: "doc2", friendlier_id: "doc2", title: "Document 2", gbl_resourceClass_sm: ["Map"], dct_accessRights_s: "Public")
    @distribution1 = DocumentDistribution.create!(document: @document1, reference_type_id: 1, url: "http://b1g.com/")
    @distribution2 = DocumentDistribution.create!(document: @document1, reference_type_id: 2, url: "https://btaa.org")
    @distribution3 = DocumentDistribution.create!(document: @document2, reference_type_id: 3, url: "https://geo.btaa.org")
  end

  test "short_name returns correct value" do
    assert_equal "Distributions", ExportCsvDocumentDistributionsService.short_name
  end

  test "call generates CSV with correct headers and data" do
    document_ids = [@document1.friendlier_id, @document2.friendlier_id]

    csv_file = ExportCsvDocumentDistributionsService.call(document_ids)

    assert_includes csv_file, DocumentDistribution.csv_column_names
    assert_includes csv_file, @distribution1.to_csv
    assert_includes csv_file, @distribution2.to_csv
    assert_includes csv_file, @distribution3.to_csv
  end

  test "call handles non-existent documents" do
    document_ids = [@document1.friendlier_id, "non_existent_id"]
    result = ExportCsvDocumentDistributionsService.call(document_ids)

    csv_string = CSV.generate do |csv|
      result.each do |row|
        csv << row
      end
    end

    csv_rows = CSV.parse(csv_string)
    assert_equal 3, csv_rows.size # Header + 2 document distributions for @document1
  end
end

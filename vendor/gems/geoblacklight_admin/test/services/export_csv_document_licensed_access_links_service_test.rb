# frozen_string_literal: true

class ExportCsvDocumentLicensedAccessLinksServiceTest < ActiveSupport::TestCase
  setup do
    @document1 = documents(:ag)
    @document2 = documents(:ls)

    # Add some debug output to verify creation
    puts "Creating test records..."
    @access1 = DocumentLicensedAccess.create!(
      document: @document1,
      institution_code: "01",
      access_url: "http://b1g.com/"
    )
    @access2 = DocumentLicensedAccess.create!(
      document: @document1,
      institution_code: "02",
      access_url: "https://btaa.org"
    )
    @access3 = DocumentLicensedAccess.create!(
      document: @document2,
      institution_code: "03",
      access_url: "https://geo.btaa.org"
    )

    # Verify records were created
    puts "Created #{DocumentLicensedAccess.count} records"
  end

  test "short_name returns expected value" do
    assert_equal "Licensed Access", ExportCsvDocumentLicensedAccessLinksService.short_name
  end

  test "call returns CSV with headers and data" do
    document_ids = [@document1.friendlier_id, @document2.friendlier_id]
    result = ExportCsvDocumentLicensedAccessLinksService.call(document_ids)

    puts "\nDocument IDs: #{document_ids}"
    puts "\nDocumentLicensedAccesses: #{DocumentLicensedAccess.count}"
    DocumentLicensedAccess.all.each do |access|
      puts "\nDocumentLicensedAccess: #{access.inspect}"
    end
    puts "\nCSV Result: #{result}"

    # Result is now an array of arrays
    csv_rows = result

    # Check headers
    assert_equal DocumentLicensedAccess.column_names, csv_rows[0]

    # Check data
    assert_equal 5, csv_rows.length # header + 4 rows (1 fixture + 3 created)
    assert_includes result.flatten, "http://b1g.com/"
    assert_includes result.flatten, "https://btaa.org"
    assert_includes result.flatten, "https://geo.btaa.org"
  end

  test "call returns empty CSV with headers when no documents found" do
    document_ids = [-1] # Non-existent ID
    result = ExportCsvDocumentLicensedAccessLinksService.call(document_ids)

    # Result is now an array of arrays
    csv_rows = result

    # Should have headers but no data
    assert_equal 1, csv_rows.length
    assert_equal DocumentLicensedAccess.column_names, csv_rows[0]
  end

  test "call handles nil document_ids" do
    assert_nothing_raised do
      ExportCsvDocumentLicensedAccessLinksService.call(nil)
    end
  end
end

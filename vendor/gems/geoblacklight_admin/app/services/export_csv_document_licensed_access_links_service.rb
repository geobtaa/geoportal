# frozen_string_literal: true

require "csv"

class ExportCsvDocumentLicensedAccessLinksService
  def self.short_name
    "Licensed Access"
  end

  def self.include_distributions?
    false
  end

  def self.call(document_ids)
    Rails.logger.debug { "\n\nExportCsvDocumentLicensedAccessLinksService: #{document_ids.inspect}\n\n" }

    csv_file = []
    csv_file << DocumentLicensedAccess.column_names
    records = DocumentLicensedAccess.where(friendlier_id: document_ids)
    Rails.logger.debug { "Found #{records.count} records" }
    records.find_each do |access|
      csv_file << access.attributes.values
    end

    csv_file
  end
end

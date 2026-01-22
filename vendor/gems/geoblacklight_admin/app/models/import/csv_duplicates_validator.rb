# frozen_string_literal: true

require "csv"

# CSV Duplicates Validator
#
# * Checks the CSV file for duplicate IDs.
# * Fails import if duplicate ID is found.
#
class Import
  # CsvDuplicatesValidator
  class CsvDuplicatesValidator < ActiveModel::Validator
    def validate(record)
      valid_csv_file = true
      duplicate_id = validate_csv_file(record.csv_file)
      unless duplicate_id.nil?
        valid_csv_file = false
        record.errors.add(:csv_file,
          "Duplicate ID value found: #{duplicate_id}. Please clean up the CSV file and reimport.")
      end

      valid_csv_file
    end

    def validate_csv_file(csv_file)
      ids = Set.new
      duplicate_id = nil
      csv = CSV.parse(csv_file.download, headers: true)

      csv["ID"].each do |id|
        duplicate_id = id unless ids.add?(id)
      end

      duplicate_id
    rescue ArgumentError, ActiveStorage::FileNotFoundError
      false
    end
  end
end

# frozen_string_literal: true

require "csv"

# CSV Header Validation
class Import
  # CsvHeaderValidator
  class CsvHeaderValidator < ActiveModel::Validator
    def validate(record)
      valid_csv_header = true
      unless valid_csv_headers?(record&.csv_file)
        valid_csv_header = false
        record.errors.add(:csv_file,
          "Missing a required CSV header. Title, Resource Class, Access Rights, and ID are required.")
      end

      valid_csv_header
    end

    def valid_csv_headers?(csv_file)
      headers = CSV.parse(csv_file.download)[0]
      (["Title", "Resource Class", "Access Rights", "ID"] - headers).empty?
    rescue ArgumentError, ActiveStorage::FileNotFoundError
      false
    end
  end
end

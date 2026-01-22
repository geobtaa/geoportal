# frozen_string_literal: true

require "csv"

# CSV Header Validation
class DocumentDataDictionary
  # CsvHeaderValidator
  class CsvHeaderValidator < ActiveModel::Validator
    def validate(record)
      valid_csv_header = true
      unless valid_csv_headers?(record&.csv_file)
        valid_csv_header = false
        record.errors.add(:csv_file,
          "Missing a required CSV header. friendlier_id, field_name, field_type, values, definition, definition_source, and parent_field_name are required.")

        # Log the CSV file content
        Rails.logger.error("CSV validation failed. CSV content: #{record.csv_file.download}")
      end

      valid_csv_header
    end

    def valid_csv_headers?(csv_file)
      headers = CSV.parse(csv_file.download)[0]
      (["friendlier_id", "field_name", "field_type", "values", "definition", "definition_source", "parent_field_name"] - headers).empty?
    rescue ArgumentError, ActiveStorage::FileNotFoundError
      false
    end
  end
end

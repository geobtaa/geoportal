# frozen_string_literal: true

require "csv"

# CSV Header Validation
class ImportDistribution
  # CsvHeaderValidator
  class CsvHeaderValidator < ActiveModel::Validator
    def validate(record)
      if record.csv_file.nil?
        record.errors.add(:csv_file, "Missing a required CSV header. friendlier_id, reference_type, distribution_url, and label are required.")
        return false
      end

      valid_csv_header = true
      unless valid_csv_headers?(record&.csv_file)
        valid_csv_header = false
        record.errors.add(:csv_file,
          "Missing a required CSV header. friendlier_id, reference_type, distribution_url, and label are required.")
      end

      valid_csv_header
    end

    def valid_csv_headers?(csv_file)
      headers = CSV.parse(csv_file.download)[0]
      (["friendlier_id", "reference_type", "distribution_url", "label"] - headers).empty?
    rescue ArgumentError, ActiveStorage::FileNotFoundError
      false
    end
  end
end

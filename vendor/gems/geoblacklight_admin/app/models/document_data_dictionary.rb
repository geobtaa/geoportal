# frozen_string_literal: true

require "csv"

class DocumentDataDictionary < ApplicationRecord
  include ActiveModel::Validations

  # Callbacks (keep at top)
  after_save :parse_csv_file

  # Associations
  has_one_attached :csv_file
  belongs_to :document, foreign_key: :friendlier_id, primary_key: :friendlier_id
  has_many :document_data_dictionary_entries, -> { order(position: :asc) }, dependent: :destroy

  # Validations
  validates :name, presence: true
  validates :csv_file, content_type: {in: "text/csv", message: "is not a CSV file"}, if: -> { csv_file.attached? }
  validates_with DocumentDataDictionary::CsvHeaderValidator, if: -> { csv_file.attached? }

  def to_csv
    CSV.generate do |csv|
      csv << DocumentDataDictionaryEntry.column_names.excluding("id", "created_at", "updated_at")
      document_data_dictionary_entries.each do |entry|
        csv << entry.attributes.values_at(*DocumentDataDictionaryEntry.column_names.excluding("id", "created_at", "updated_at"))
      end
    end
  end

  def parse_csv_file
    if csv_file.attached?
      csv_data = CSV.parse(csv_file.download, headers: true)
      csv_data.each do |row|
        entry = document_data_dictionary_entries.find_or_initialize_by(
          friendlier_id: row["friendlier_id"],
          field_name: row["field_name"]
        )
        entry.update(row.to_h)
      end
    end
  end

  def self.sort_entries(id_array)
    transaction do
      logger.debug { id_array.inspect }
      id_array.each_with_index do |entry_id, i|
        DocumentDataDictionaryEntry.update(entry_id, position: i)
      end
    end
  end
end

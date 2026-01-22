# frozen_string_literal: true

require "csv"

# DocumentLicensedAccess
class DocumentLicensedAccess < ApplicationRecord
  belongs_to :document, foreign_key: :friendlier_id, primary_key: :friendlier_id
  after_save :reindex_document

  # Validations
  validates :access_url, presence: true
  validates :institution_code, presence: true
  validates :institution_code, uniqueness: {scope: :friendlier_id}

  def self.import(file)
    logger.debug("CSV Import")
    ::CSV.foreach(file.path, headers: true) do |row|
      logger.debug("CSV Row: #{row.to_hash}")
      document_licensed_access = DocumentLicensedAccess.find_or_initialize_by(friendlier_id: row[0], institution_code: row[1])
      document_licensed_access.update!(row.to_hash)
    end
    true
  end

  def self.destroy_all(file)
    logger.debug("CSV Destroy")
    ::CSV.foreach(file.path, headers: true) do |row|
      logger.debug("CSV Row: #{row.to_hash}")
      DocumentLicensedAccess.destroy_by(id: row[0], friendlier_id: row[1])
    end
    true
  end

  def to_csv
    attributes.values
  end

  def reindex_document
    document.save
  end
end

# frozen_string_literal: true

require "csv"

# DocumentDistribution
#
# This class represents a distribution of a document, which includes a URL and a distribution type.
# It belongs to a document and a reference type, and it supports CSV import and export.
#
# Associations:
# - belongs_to :document
# - belongs_to :reference_type
#
# Callbacks:
# - after_save :reindex_document
# - after_destroy :reindex_document
#
# Validations:
# - Validates presence of :friendlier_id, :reference_type_id, :url
# - Validates uniqueness of :url scoped to :friendlier_id and :reference_type_id
#
# Scopes:
# - to_aardvark_distributions: Converts distributions to aardvark format
# - to_csv: Converts distributions to CSV format
class DocumentDistribution < ApplicationRecord
  belongs_to :document, foreign_key: :friendlier_id, primary_key: :friendlier_id
  belongs_to :reference_type
  after_save :reindex_document
  after_destroy :reindex_document

  # Validations
  validates :friendlier_id, :reference_type_id, :url, presence: true
  validates :url, uniqueness: {scope: [:friendlier_id, :reference_type_id]}

  # Scopes
  scope :to_aardvark_distributions, -> {
    distributions = where(friendlier_id: pluck(:friendlier_id)).map(&:to_aardvark_distribution)
    merged = {}
    distributions.each do |dist|
      if dist.keys.first == "http://schema.org/downloadUrl"
        merged["http://schema.org/downloadUrl"] ||= []
        merged["http://schema.org/downloadUrl"] << {
          "url" => dist.values.first,
          "label" => dist["label"].present? ? dist["label"] : dist.values.first
        }
      else
        merged[dist.keys.first] = dist.values.first
      end
    end
    merged
  }
  scope :to_csv, -> { where(friendlier_id: pluck(:friendlier_id)).map(&:to_csv) }

  # CSV Column Names
  #
  # Returns an array of column names for CSV export.
  #
  # @return [Array<String>] the CSV column names
  def self.csv_column_names
    ["friendlier_id", "reference_type", "distribution_url", "label"]
  end

  # Import
  #
  # Imports document distributions from a CSV file.
  #
  # @param file [File] the CSV file to import
  # @return [Boolean] true if import is successful
  def self.import(file)
    @errors = []

    logger.debug("CSV Import")
    ::CSV.foreach(file.path, headers: true) do |row|
      logger.debug("CSV Row: #{row.to_hash}")

      unless Document.exists?(friendlier_id: row.to_hash["friendlier_id"])
        logger.debug("Document not found: #{row.to_hash["friendlier_id"]}")
        @errors << "Document not found: #{row.to_hash["friendlier_id"]}"
        next
      end

      document_distribution = DocumentDistribution.find_or_initialize_by(
        friendlier_id: row.to_hash["friendlier_id"],
        reference_type_id: ReferenceType.find_by(name: row.to_hash["reference_type"]).id,
        url: row.to_hash["distribution_url"]
      )

      logger.debug("Document Distribution: #{document_distribution.inspect}")

      document_distribution.update!(
        friendlier_id: row.to_hash["friendlier_id"],
        reference_type_id: ReferenceType.find_by(name: row.to_hash["reference_type"]).id,
        url: row.to_hash["distribution_url"],
        label: row.to_hash["label"]
      )
    end
    [@errors.empty?, @errors]
  end

  # Destroy All
  #
  # Destroys document distributions based on a CSV file.
  #
  # @param file [File] the CSV file to process
  # @return [Boolean] true if destroy is successful
  def self.destroy_all(file)
    logger.debug("CSV Destroy")
    ::CSV.foreach(file.path, headers: true) do |row|
      logger.debug("CSV Row: #{row.to_hash}")
      if DocumentDistribution.destroy_by(
        friendlier_id: row.to_hash["friendlier_id"],
        reference_type_id: ReferenceType.find_by(name: row.to_hash["reference_type"]).id,
        url: row.to_hash["distribution_url"]
      )
        logger.debug("Destroyed: #{row.to_hash}")
      else
        logger.debug("Not Destroyed: #{row.to_hash}")
      end
    end
    true
  end

  # To CSV
  #
  # Converts the document distribution to an array suitable for CSV export.
  #
  # @return [Array<String>] the CSV row data
  def to_csv
    [
      friendlier_id,
      reference_type.name,
      url,
      label
    ]
  end

  # To Aardvark Reference
  #
  # Converts the document distribution to an aardvark distribution format.
  #
  # @return [Hash] the aardvark reference
  def to_aardvark_distribution
    hash = {}
    hash[reference_type.reference_uri.to_s] = url
    hash["label"] = label if reference_type.reference_uri.to_s == "http://schema.org/downloadUrl"
    hash
  end

  # Reindex Document
  #
  # Reindexes the associated document.
  def reindex_document
    document.save
  end
end

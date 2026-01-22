# frozen_string_literal: true

require "csv"

# Import class
class Import < ApplicationRecord
  include ActiveModel::Validations

  # Callbacks (keep at top)
  after_commit :set_csv_file_attributes, if: :persisted?
  after_commit :check_if_mapped, if: :persisted?

  # Associations
  has_one_attached :csv_file
  has_many :documents
  has_many :import_documents, dependent: :destroy
  has_many :import_transitions, autosave: false, dependent: :destroy
  has_many :mappings, -> { order(:id) }, dependent: :destroy, inverse_of: :import
  accepts_nested_attributes_for :mappings

  # Validations
  validates :name, :type, presence: true
  validates :csv_file, attached: true, content_type: {in: "text/csv", message: "is not a CSV file"}

  validates_with Import::CsvHeaderValidator
  validates_with Import::CsvDuplicatesValidator

  # States
  include Statesman::Adapters::ActiveRecordQueries[
    transition_class: ImportTransition,
    initial_state: :created
  ]

  def state_machine
    @state_machine ||= ImportStateMachine.new(self, transition_class: ImportTransition)
  end

  def set_csv_file_attributes
    parsed = CSV.parse(csv_file.download)

    update_columns(
      headers: parsed[0],
      row_count: parsed.size - 1,
      content_type: csv_file.content_type.to_s,
      filename: csv_file.filename.to_s,
      extension: csv_file.filename.extension.to_s
    )
  end

  def check_if_mapped
    state_machine.transition_to!(:mapped) if mappings_valid? && state_machine.can_transition_to?(:mapped)
  end

  def all_mapping_keys
    database = mappings.collect(&:destination_field)
    default = default_mappings.collect(&:keys)
    assumed = assumed_mappings.collect(&:values)

    mappings = (database + default + assumed).flatten
    mappings.map(&:to_s)
  end

  def mappings_valid?
    (GEOMG_SCHEMA[:required] - all_mapping_keys.uniq).empty?
  end

  def run!
    # @TODO: guard this call, unless mappings_valid?

    # Queue Job
    ImportRunJob.perform_later(self)

    # Capture State
    state_machine.transition_to!(:imported)
    save
  end

  def convert_data(extract_hash)
    converted_data = transform_extract(extract_hash)
    converted_data = append_default_mappings(converted_data)
    converted_data = append_assumed_mappings(converted_data)
    converted_data = append_derived_mappings(converted_data)
    append_required_mappings(converted_data)
  end

  private

  def create_import_document(kithe_document)
  end

  def transform_extract(extract_hash)
    transformed_data = {}
    mappings.each do |mapping|
      # logger.debug("Mapping: #{mapping.source_header} to #{mapping.destination_field}")

      # Handle discards
      next if mapping.destination_field == "Discard"

      # Handle repeatable dct_references_s entries
      if mapping.destination_field == "dct_references_s"
        transformed_data[mapping.destination_field] ||= []
        if extract_hash[mapping.source_header].present?
          transformed_data[mapping.destination_field] << {
            category: GeoblacklightAdmin::Schema.instance.dct_references_mappings[mapping.source_header.to_sym],
            value: extract_hash[mapping.source_header]
          }
        end
      # Handle solr_geom transformation
      elsif mapping.destination_field == "solr_geom"
        transformed_data[mapping.destination_field] = solr_geom_mapping(extract_hash[mapping.source_header])

      # Lastly, set existing values
      else
        transformed_data[mapping.destination_field] = extract_hash[mapping.source_header]
      end

      # Split delimited field values, if field has a value present
      if mapping.delimited?
        transformed_data[mapping.destination_field] =
          transformed_data[mapping.destination_field].present? ? transformed_data[mapping.destination_field].split(klass_delimiter) : ""
      end
    end

    transformed_data
  end

  # Merges an array of hashes into the data hash
  def append_default_mappings(data_hash)
    default_mappings.each do |mapping|
      data_hash.merge!(mapping.stringify_keys)
    end

    data_hash
  end

  # Merges copied value hashes into the data hash
  def append_assumed_mappings(data_hash)
    assumed_mappings.each do |mapping|
      mapping.each do |key, value|
        assumed_mapping = {}
        assumed_mapping[value] = data_hash[key.to_s]
        data_hash.merge!(assumed_mapping)
      end
    end

    data_hash
  end

  # Merges derived value hashes into the data hash
  # Takes value from data hash, manipulates it, stores in new hash entry
  #
  # Ex. solr_geom is used to calc the b1g_centroid_ss value
  def append_derived_mappings(data_hash)
    derived_mappings.each do |mapping|
      mapping.each do |key, value|
        derived_mapping = {}

        args = {data_hash: data_hash.dup, field: value[:field]}
        derived_mapping[key] = send(value[:method], args)

        data_hash.merge!(derived_mapping.stringify_keys)
      end
    end

    data_hash
  end

  # Ensures required values are in the data hash
  #
  # ex. field_name is required.
  def append_required_mappings(data_hash)
    required_mappings.each do |mapping|
      mapping.each do |key, value|
        required_mapping = {}
        required_mapping[key] = value

        data_hash.merge!(required_mapping.stringify_keys) unless data_hash.key?(key)
      end
    end

    data_hash
  end
end

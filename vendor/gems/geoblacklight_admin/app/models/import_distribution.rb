# frozen_string_literal: true

require "csv"

# ImportDistribution class
class ImportDistribution < ApplicationRecord
  include ActiveModel::Validations

  # Callbacks (keep at top)
  after_commit :set_csv_file_attributes, if: :persisted?

  # Associations
  has_one_attached :csv_file
  has_many :document_distributions, dependent: :destroy
  has_many :import_document_distributions, dependent: :destroy
  has_many :import_distribution_transitions, autosave: false, dependent: :destroy

  # Validations
  validates :csv_file, attached: true, content_type: {in: "text/csv", message: "is not a CSV file"}

  validates_with ImportDistribution::CsvHeaderValidator

  # States
  include Statesman::Adapters::ActiveRecordQueries[
    transition_class: ImportDistributionTransition,
    initial_state: :created
  ]

  def state_machine
    @state_machine ||= ImportDistributionStateMachine.new(self, transition_class: ImportDistributionTransition)
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

  def run!
    # @TODO: guard this call, unless mappings_valid?

    # Queue Job
    ImportDistributionsRunJob.perform_later(self)

    # Capture State
    state_machine.transition_to!(:imported)
    save
  end
end

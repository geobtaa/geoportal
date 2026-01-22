# frozen_string_literal: true

# ImportDocumentDistribution class
class ImportDocumentDistribution < ApplicationRecord
  has_many :import_document_distribution_transitions, autosave: false, dependent: :destroy

  include Statesman::Adapters::ActiveRecordQueries[
    transition_class: ImportDocumentDistributionTransition,
    initial_state: :queued
  ]

  def state_machine
    @state_machine ||= ImportDocumentDistributionStateMachine.new(self, transition_class: ImportDocumentDistributionTransition)
  end

  def to_hash
    {
      friendlier_id: friendlier_id,
      reference_type: ReferenceType.find_by(name: reference_type),
      url: distribution_url,
      label: label,
      import_distribution_id: import_distribution_id
    }
  end
end

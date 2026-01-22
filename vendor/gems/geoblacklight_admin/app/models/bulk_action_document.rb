# frozen_string_literal: true

# BulkActionDocument class
class BulkActionDocument < ApplicationRecord
  has_many :bulk_action_document_transitions, autosave: false, dependent: :destroy

  include Statesman::Adapters::ActiveRecordQueries[
    transition_class: BulkActionDocumentTransition,
    initial_state: :queued
  ]

  def state_machine
    @state_machine ||= BulkActionDocumentStateMachine.new(self, transition_class: BulkActionDocumentTransition)
  end

  # @TODO: Needed?
  def to_hash
    {
      friendlier_id: friendlier_id
    }
  end
end

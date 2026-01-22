# frozen_string_literal: true

# Add BulkActionDocument Statesman Transitions
class BulkActionDocumentTransition < ApplicationRecord
  include Statesman::Adapters::ActiveRecordTransition

  belongs_to :bulk_action_document, inverse_of: :bulk_action_document_transitions

  after_destroy :update_most_recent, if: :most_recent?

  private

  def update_most_recent
    last_transition = bulk_action_document.bulk_action_document_transitions.order(:sort_key).last
    return if last_transition.blank?

    last_transition.update_column(:most_recent, true)
  end
end

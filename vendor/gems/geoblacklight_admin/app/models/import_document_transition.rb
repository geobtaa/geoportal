# frozen_string_literal: true

# Add ImportDocument Statesman Transitions
class ImportDocumentTransition < ApplicationRecord
  include Statesman::Adapters::ActiveRecordTransition

  belongs_to :import_document, inverse_of: :import_document_transitions

  after_destroy :update_most_recent, if: :most_recent?

  private

  def update_most_recent
    last_transition = import_document.import_document_transitions.order(:sort_key).last
    return if last_transition.blank?

    last_transition.update_column(:most_recent, true)
  end
end

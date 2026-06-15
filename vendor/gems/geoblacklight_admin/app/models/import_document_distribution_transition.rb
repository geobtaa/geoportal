# frozen_string_literal: true

# Add ImportDocumentDistribution Statesman Transitions
class ImportDocumentDistributionTransition < ApplicationRecord
  include Statesman::Adapters::ActiveRecordTransition

  belongs_to :import_document_distribution, inverse_of: :import_document_distribution_transitions

  after_destroy :update_most_recent, if: :most_recent?

  private

  def update_most_recent
    last_transition = import_document_distribution.import_document_distribution_transitions.order(:sort_key).last
    return if last_transition.blank?

    last_transition.update_column(:most_recent, true)
  end
end

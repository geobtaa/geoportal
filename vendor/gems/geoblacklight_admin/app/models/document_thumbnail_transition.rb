# frozen_string_literal: true

# Add Document Thumbnail State Transitions
class DocumentThumbnailTransition < ApplicationRecord
  include Statesman::Adapters::ActiveRecordTransition

  # If your transition table doesn't have the default `updated_at` timestamp column,
  # you'll need to configure the `updated_timestamp_column` option, setting it to
  # another column name (e.g. `:updated_on`) or `nil`.
  #
  # self.updated_timestamp_column = :updated_on
  # self.updated_timestamp_column = nil

  belongs_to :document, inverse_of: :document_thumbnail_transitions, foreign_key: "kithe_model_id"

  after_destroy :update_most_recent, if: :most_recent?

  private

  def update_most_recent
    last_transition = document.document_thumbnail_transitions.order(:sort_key).last
    return if last_transition.blank?

    last_transition.update_column(:most_recent, true)
  end
end

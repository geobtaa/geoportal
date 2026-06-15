# frozen_string_literal: true

class DocumentDownload < ApplicationRecord
  belongs_to :document, foreign_key: :friendlier_id, primary_key: :friendlier_id

  after_save :kithe_bridge_touch_parent_document
  after_destroy :kithe_bridge_touch_parent_document

  private

  def kithe_bridge_touch_parent_document
    return unless defined?(KitheBridgeChangeCapture)

    KitheBridgeChangeCapture.touch_parent_document!(document)
  end
end


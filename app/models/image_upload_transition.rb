# frozen_string_literal: true

class ImageUploadTransition < ApplicationRecord
  include Statesman::Adapters::ActiveRecordTransition

  belongs_to :solr_document_sidecar, inverse_of: :image_upload_transitions
end

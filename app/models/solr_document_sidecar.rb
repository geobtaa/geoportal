# frozen_string_literal: true

##
# Metadata for indexed documents
class SolrDocumentSidecar < ApplicationRecord
  include Statesman::Adapters::ActiveRecordQueries
  mount_uploader :image, ImageUploader

  belongs_to :document, required: true, polymorphic: true
  has_many :image_upload_transitions, autosave: false, dependent: :destroy

  # If the sidecar is updated, need to re-fetch thumbnail image
  # after_update :reimage, if: :saved_change_to_version?

  # Roll our own polymorphism because our documents are not AREL-able
  def document
    document_type.new document_type.unique_key => document_id
  end

  def document_type
    (super.constantize if defined?(super)) || default_document_type
  end

  def state_machine
    @state_machine ||= ImageUploadStateMachine.new(self, transition_class: ImageUploadTransition)
  end

  def self.transition_class
    ImageUploadTransition
  end

  def self.initial_state
    :initialized
  end

  private_class_method :initial_state

  # private
  #
  # def reimage
  #  StoreImageJob.perform_later(self.document.to_h)
  # end
end

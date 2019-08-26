# frozen_string_literal: true

##
# Metadata for indexed documents
class SolrDocumentSidecar < ApplicationRecord
  include Statesman::Adapters::ActiveRecordQueries

  # Deprecated - Carrierwave
  mount_uploader :image, ImageUploader

  # ActiveStorage
  has_one_attached :as_image

  belongs_to :document, required: true, polymorphic: true
  has_many :image_upload_transitions, autosave: false, dependent: :destroy
  has_many :sidecar_image_transitions, autosave: false, dependent: :destroy

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
    @state_machine ||= ImageUploadStateMachine.new(
      self,
      transition_class: ImageUploadTransition
    )
  end

  def image_state
    @image_state ||= SidecarImageStateMachine.new(
      self,
      transition_class: SidecarImageTransition
    )
  end

  def self.transition_class
    # ImageUploadTransition   - Old
    SidecarImageTransition #  - New
  end

  def self.initial_state
    :initialized
  end

  def self.image_url
    Rails.application.routes.url_helpers.rails_blob_path(image, only_path: true)
  end

  def reimage!
    image.purge if image.attached?
    GeoblacklightSidecarImages::StoreImageJob.perform_later(document.id)
  end

  private_class_method :initial_state
end

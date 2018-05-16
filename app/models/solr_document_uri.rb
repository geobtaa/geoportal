# frozen_string_literal: true

class SolrDocumentUri < ApplicationRecord
  include Statesman::Adapters::ActiveRecordQueries

  belongs_to :document, required: true, polymorphic: true
  has_many :uri_transitions, autosave: false, dependent: :destroy

  # Roll our own polymorphism because our documents are not AREL-able
  def document
    document_type.new document_type.unique_key => document_id
  end

  def document_type
    (super.constantize if defined?(super)) || default_document_type
  end

  def state_machine
    @state_machine ||= UriStateMachine.new(self, transition_class: UriTransition)
  end

  def self.transition_class
    UriTransition
  end

  def self.initial_state
    :initialized
  end
end

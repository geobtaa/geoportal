# frozen_string_literal: true

require "uri"
require "cgi"
require "statesman"

# BulkAction
class BulkAction < ApplicationRecord
  # Callbacks
  after_create do
    BulkActionCollectDocuments.perform_later(id)
  end

  # Associations
  has_many :documents, class_name: "BulkActionDocument", autosave: false, dependent: :destroy

  has_many :bulk_action_transitions, autosave: false, dependent: :destroy

  # Validations
  validates :scope, :field_name, :field_value, presence: true

  # States
  include ::Statesman::Adapters::ActiveRecordQueries[
    transition_class: BulkActionTransition,
    initial_state: :created
  ]

  def state_machine
    @state_machine ||= BulkActionStateMachine.new(self, transition_class: BulkActionTransition)
  end

  def run!
    # @TODO: guard this call for validation?

    # Queue Job
    BulkActionRunJob.perform_later(self)

    # Capture State
    # state_machine.transition_to!(:imported)
    # save
  end

  def check_run_state
    nil if state_machine.current_state == "complete"

    # @TODO / background job for collecting documents
    # state_machine.transition_to!(:complete) if documents.in_state(:queued).blank?
  end

  def revert!
    # Queue Revert Job
    BulkActionRevertJob.perform_later(self)
  end

  def collect_documents
    cgi = CGI.unescape(scope)
    uri = URI.parse(cgi)
    if uri.path.include?("fetch")
      fetch_documents(uri)
    else
      api_documents(uri)
    end
  end

  private

  def fetch_documents(uri)
    qargs = Rack::Utils.parse_nested_query(uri.query)
    fetch_documents = Document.where(friendlier_id: qargs["ids"])
    create_documents(fetch_documents)
  end

  def api_documents(uri)
    qargs = Rack::Utils.parse_nested_query(uri.query)
    query_params = {q: qargs["q"], f: qargs["f"], page: qargs["page"], rows: 1_000_000}
    api_documents = BlacklightApiIds.new(request, **query_params)
    create_documents(api_documents.load_all)
  end

  def create_documents(documents)
    documents.collect do |doc|
      BulkActionDocument.create(
        document_id: doc.id,
        friendlier_id: doc.friendlier_id,
        version: doc.current_version,
        bulk_action_id: id
      )
    rescue
      logger.debug("BULK ACTION BAD DOC: #{doc.inspect}")
    end
  end
end

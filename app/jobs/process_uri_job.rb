# frozen_string_literal: true

class ProcessUriJob < ApplicationJob
  queue_as :default

  def perform(uri_id)
    uri = SolrDocumentUri.find(uri_id)

    metadata = {}
    metadata['solr_doc_id'] = uri.document_id
    metadata['solr_version'] = uri.version

    uri.state_machine.transition_to!(:queued, metadata)
    UriService.new(uri).process
  end
end

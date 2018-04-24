# frozen_string_literal: true

class StoreImageJob < ApplicationJob
  queue_as :default

  def perform(document_hash)
    document = SolrDocument.new(document_hash)

    metadata = Hash.new
    metadata['solr_doc_id'] = document.id
    metadata['solr_version'] = document.sidecar.version

    document.sidecar.state_machine.transition_to!(:queued, metadata)
    ImageService.new(document).store
  end
end

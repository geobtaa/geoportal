# frozen_string_literal: true

class StoreImageJob < ApplicationJob
  queue_as :default

  def perform(document_hash)
    document = SolrDocument.new(document_hash)
    document.sidecar.state_machine.transition_to!(:queued)
    ImageService.new(document).store
  end
end

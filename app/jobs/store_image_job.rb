# frozen_string_literal: true

class StoreImageJob < ApplicationJob
  queue_as :default

  def perform(document_hash)
    doc = SolrDocument.new(document_hash)
    ImageService.new(doc).store
  end
end

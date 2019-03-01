# frozen_string_literal: true

class UriTransition < ApplicationRecord
  include Statesman::Adapters::ActiveRecordTransition

  belongs_to :solr_document_uri, inverse_of: :uri_transitions
end

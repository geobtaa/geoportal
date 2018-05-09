class UriTransition < ActiveRecord::Base
  include Statesman::Adapters::ActiveRecordTransition

  belongs_to :solr_document_uri, inverse_of: :uri_transitions
end

# frozen_string_literal: true

json.extract! document_licensed_access, :id, :kithe_model_id, :institution_code, :access_url, :created_at, :updated_at
json.url document_licensed_access_url(document_licensed_access, format: :json)

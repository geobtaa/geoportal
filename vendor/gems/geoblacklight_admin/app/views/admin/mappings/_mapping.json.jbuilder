# frozen_string_literal: true

json.extract! mapping, :id, :source_header, :destination_field, :delimited, :transformation_method, :import_id,
  :created_at, :updated_at
json.url mapping_url(mapping, format: :json)

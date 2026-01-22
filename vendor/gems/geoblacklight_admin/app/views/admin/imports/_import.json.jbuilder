# frozen_string_literal: true

json.extract! import, :id, :name, :filename, :source, :description, :row_count, :headers, :encoding, :content_type,
  :extension, :validity, :validation_result, :created_at, :updated_at
json.url import_url(import, format: :json)

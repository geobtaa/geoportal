# frozen_string_literal: true

json.extract! form_element, :id, :type, :heading, :element_solr_field, :created_at, :updated_at
json.url form_element_url(form_element, format: :json)

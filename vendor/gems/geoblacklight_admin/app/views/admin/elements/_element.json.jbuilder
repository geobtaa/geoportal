# frozen_string_literal: true

json.extract! element, :id, :label, :solr_field, :field_definition, :field_type, :required, :repeatable, :formable,
  :placeholder_text, :data_entry_hint, :test_fixture_example, :controlled_vocabulary, :js_behaviors, :html_attributes, :display_only_on_persisted, :importable, :import_deliminated, :import_transformation_method, :exportable, :export_transformation_method, :indexable, :index_transformation_method, :validation_method, :created_at, :updated_at
json.url element_url(element, format: :json)

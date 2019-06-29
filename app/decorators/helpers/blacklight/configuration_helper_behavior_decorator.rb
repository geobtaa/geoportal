Blacklight::ConfigurationHelperBehavior.class_eval do
  ##
  # @CUSTOMIZED: added label pluralize call
  # Look up the label for the show field
  def document_show_field_label document, field
    field_config = blacklight_config.show_fields_for(document)[field]

    field_label(
      :"blacklight.search.fields.show.#{field}",
      :"blacklight.search.fields.#{field}",
      (field_config.label if field_config),
      field.to_s.humanize
    ).pluralize(Array.wrap(document.fetch(field, field)).count)
  end
end

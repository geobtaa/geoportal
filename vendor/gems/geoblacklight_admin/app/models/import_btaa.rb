# frozen_string_literal: true

# Import BTAA
class ImportBtaa < Import
  # validations, constants and methods

  def mapping_configuration
    GeoblacklightAdmin::Schema.instance.importable_fields
  end

  def klass_delimiter
    "|"
  end

  # Solr Field => Hard Value
  def default_mappings
    [
      {gbl_mdVersion_s: "Aardvark"}
    ]
  end

  # Copy Value from Field to Field
  def assumed_mappings
    # No longer assuming identfier == slug
    # [
    #   { 'dc_identifier_s': 'layer_slug_s' }
    # ]
    # Return empty array
    []
  end

  # Derived Values
  def derived_mappings
    [
      {
        dcat_centroid:
          {
            field: "dcat_bbox",
            method: "derive_dcat_centroid"
          }
      },
      {
        gbl_georeferenced_b:
          {
            field: "gbl_georeferenced_b",
            method: "derive_boolean"
          }
      },
      {
        gbl_suppressed_b:
          {
            field: "gbl_suppressed_b",
            method: "derive_boolean"
          }
      }
    ]
  end

  # Required Values
  # Key / Default Value
  # Example: { field_name: 'default_value' }
  def required_mappings
    []
  end

  def derive_dcat_centroid(args)
    data_hash = args[:data_hash]
    field = args[:field]

    return if data_hash[field].blank?

    w, s, e, n = data_hash[field].split(",")
    "#{(n.to_f + s.to_f) / 2},#{(e.to_f + w.to_f) / 2}"
  end

  def derive_boolean(args)
    data_hash = args[:data_hash]
    field = args[:field]

    return false if data_hash[field].blank?

    ActiveModel::Type::Boolean.new.cast(data_hash[field].downcase)
  end
end

# frozen_string_literal: true

# Import GBLv1
class ImportBtaaAardvark < Import
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
      {dct_references_s:
        {
          field: "dct_references_s",
          method: "geomg_dct_references_s"
        }},
      {gbl_dateRange_drsim:
        {
          field: "gbl_dateRange_drsim",
          method: "geomg_b1g_date_range_drsim"
        }},
      {locn_geometry:
        {
          field: "locn_geometry",
          method: "solr_geom_mapping"
        }}
    ]
  end

  # Required Values
  # Key / Default Value
  def required_mappings
    []
  end

  def solr_geom_mapping(args)
    data_hash = args[:data_hash]
    field = args[:field]

    # Example: "ENVELOPE(-87\\, -85.76\\, 39.78\\, 37.96)"
    geom = data_hash[field]
    if geom.present?
      geom = geom&.delete("ENVELOPE(")
      geom = geom&.delete(")")
      geom = geom&.delete("\\")
      w, e, n, s = geom.split(",")
      "#{w},#{s},#{e},#{n}"
    else
      ""
    end
  end

  def geomg_b1g_date_range_drsim(args)
    data_hash = args[:data_hash]
    field = args[:field]

    # Ex. [2020 TO 2020], [* TO 2020], [2020 TO *]
    date_range = nil
    date_range = data_hash[field][0] unless data_hash[field].empty?
    date_range = date_range[1..12]&.gsub(" TO ", "-") unless date_range.nil?
    date_range
  end

  def geomg_dct_references_s(args)
    data_hash = args[:data_hash]
    field = args[:field]
    references = []

    unless data_hash[field].empty?
      dct_references = data_hash[field][0]
      json_data = JSON.parse(dct_references[:value])

      json_data.each do |key, value|
        reference = {
          value: value,
          category: GeoblacklightAdmin::FieldMappingsBtaaAardvark.uri_2_category_references_mappings[key]
        }
        references << reference
      end
    end

    references
  end
end

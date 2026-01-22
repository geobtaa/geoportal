# frozen_string_literal: true

# MappingsHelper
#
# This module provides helper methods for handling mappings in the application.
# It includes methods to generate attribute collections and provide mapping
# and delimiter suggestions based on import configurations.
module MappingsHelper
  # Returns a collection of attributes that can be used for mapping.
  #
  # The collection is generated from importable elements, sorted, and includes
  # additional options for an empty string and "Discard".
  #
  # @return [Array<String>] a sorted array of attribute names with additional options.
  def attribute_collection
    attrs = Element.importable.map(&:solr_field).sort
    attrs.prepend("")
    attrs.prepend("Discard")
    attrs
  end

  # Provides a mapping suggestion for a given header based on the import configuration.
  #
  # Checks if the header is included in the import's mapping configuration and returns
  # the destination if available.
  #
  # @param import [Object] the import object containing mapping configurations.
  # @param header [String] the header for which the mapping suggestion is needed.
  # @return [String, false] the destination mapping if available, otherwise false.
  def mapping_suggestion(import, header)
    if import.mapping_configuration.include?(header.to_sym)
      import.mapping_configuration[header.to_sym][:destination]
    else
      false
    end
  end

  # Provides a delimiter suggestion for a given header based on the import configuration.
  #
  # Checks if the header is included in the import's mapping configuration and returns
  # the delimiter if available.
  #
  # @param import [Object] the import object containing mapping configurations.
  # @param header [String] the header for which the delimiter suggestion is needed.
  # @return [String, false] the delimiter if available, otherwise false.
  def delimiter_suggestion(import, header)
    if import.mapping_configuration.include?(header.to_sym)
      import.mapping_configuration[header.to_sym][:delimited]
    else
      false
    end
  end
end

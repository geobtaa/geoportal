# frozen_string_literal: true

# GeoblacklightAdminHelper
#
# This module provides helper methods for the GeoBlacklight admin interface.
# It includes methods for handling JSON data, generating paths, formatting
# flash messages, and more.
module GeoblacklightAdminHelper
  # @TODO:
  # Cannot generate app if uncommented...
  # Uncomment after app is generated to fix view errors
  include ::Pagy::Frontend if defined?(Pagy)

  # Removes blank values from JSON data.
  #
  # @param value [String, Array] the value to check for presence
  # @return [String, Array, nil] the original value if present, otherwise nil
  def no_json_blanks(value)
    case value
    when String
      value.presence
    when Array
      value.join.blank? ? nil : value
    end
  end

  # Generates a search path for the QA (questioning_authority) gem.
  #
  # @param vocab [String] the vocabulary to search
  # @param subauthority [String, nil] the subauthority to search
  # @return [String] the generated search path
  def qa_search_vocab_path(vocab, subauthority = nil)
    path = "/authorities/search/#{CGI.escape vocab}"
    path += "/#{CGI.escape subauthority}" if subauthority
    path
  end

  # Maps flash message levels to CSS classes.
  #
  # @param level [String] the flash message level
  # @return [String] the corresponding CSS class
  def flash_class(level)
    alerts = {
      "notice" => "alert alert-info",
      "success" => "alert alert-success",
      "error" => "alert alert-error",
      "alert" => "alert alert-error"
    }
    alerts[level]
  end

  # Provides a mapping of institution codes to institution names.
  #
  # @return [Hash] a hash mapping institution codes to names
  def b1g_institution_codes
    {
      "01" => "Indiana University",
      "02" => "University of Illinois Urbana-Champaign",
      "03" => "University of Iowa",
      "04" => "University of Maryland",
      "05" => "University of Minnesota",
      "06" => "Michigan State University",
      "07" => "University of Michigan",
      "08" => "Purdue University",
      "09" => "Pennsylvania State University",
      "10" => "University of Wisconsin-Madison",
      "11" => "The Ohio State University",
      "12" => "University of Chicago",
      "13" => "University of Nebraska-Lincoln",
      "14" => "Rutgers University-New Brunswick",
      "15" => "Northwestern University"
    }
  end

  # Generates an HTML badge for bookmarks.
  #
  # @return [String] the HTML string for the bookmarks badge
  def bookmarks_badge
    bookmarks_classes = ["badge", "badge-dark"]
    "<span class='#{bookmarks_classes.join(" ")}' id='bookmarks-count'>#{current_user.bookmarks.size}</span>"
  end

  # Generates an HTML badge for notifications.
  #
  # @return [String] the HTML string for the notifications badge
  def notifications_badge
    notifications_classes = ["badge"]
    notifications_classes << "badge-dark" if current_user.notifications.unread.empty?
    notifications_classes << "badge-danger" if current_user.notifications.unread.size.positive?
    "<span class='#{notifications_classes.join(" ")}' id='notification-count'>#{current_user.notifications.unread.size}</span>"
  end

  # Converts parameters into hidden form fields.
  #
  # @param params [Hash] the parameters to convert
  # @return [String] the HTML string of hidden fields
  def params_as_hidden_fields(params)
    hidden_fields = []
    flatten_hash(params).each do |name, value|
      value = Array.wrap(value)
      value.each do |v|
        hidden_fields << hidden_field_tag(name, v.to_s, id: nil)
      end
    end

    safe_join(hidden_fields, "\n")
  end

  # Flattens a nested hash into a single-level hash with keys representing the
  # nested structure.
  #
  # @param hash [Hash] the hash to flatten
  # @param ancestor_names [Array] the ancestor keys for nested hashes
  # @return [Hash] the flattened hash
  def flatten_hash(hash, ancestor_names = [])
    flat_hash = {}
    hash.each do |k, v|
      names = Array.new(ancestor_names)
      names << k
      if v.is_a?(Hash)
        flat_hash.merge!(flatten_hash(v, names))
      else
        key = flat_hash_key(names)
        key += "[]" if v.is_a?(Array)
        flat_hash[key] = v
      end
    end

    flat_hash
  end

  # Generates a key for a flattened hash from an array of names.
  #
  # @param names [Array] the array of names
  # @return [String] the generated key
  def flat_hash_key(names)
    names = Array.new(names)
    name = names.shift.to_s.dup
    names.each do |n|
      name << "[#{n}]"
    end
    name
  end

  # Maps a character to a CSS class for diff highlighting.
  #
  # @param char [String] the character representing a diff operation
  # @return [String] the corresponding CSS class
  def diff_class(char)
    case char
    when "~"
      "table-warning"
    when "-"
      "table-danger"
    when "+"
      "table-success"
    else
      ""
    end
  end

  # Generates a link to the admin import page for a given import.
  #
  # @param import [Object] the import object
  # @return [String] the HTML link to the admin import page
  def link_to_admin_import(import)
    path = admin_documents_path(
      {
        f: {b1g_geom_import_id_ssi: [import]}
      }
    )

    link_to import.name, path
  end

  # Generates a link to the GeoBlacklight import page with optional state.
  #
  # @param label [String] the link label
  # @param import [Object] the import object
  # @param state [Boolean] the publication state
  # @return [String] the HTML link to the GeoBlacklight import page
  def link_to_gbl_import(label, import, state = false)
    path = if state
      blacklight_path(
        {
          f: {b1g_geom_import_id_ssi: [import]},
          publication_state: state
        }
      )
    else
      blacklight_path(
        {
          f: {b1g_geom_import_id_ssi: [import]},
          publication_state: "*"
        }
      )
    end

    link_to(label, path)
  end

  # Generates options for asset DCT references.
  #
  # @return [String] the escaped JavaScript string of options
  def assets_dct_references_options
    escape_javascript(options_for_select(I18n.t("activemodel.asset_enum_values.document/reference.category").invert.sort.insert(0, ["Choose Reference Type", nil]))).to_s
  end

  # Determines if a document's thumbnail should be rendered.
  #
  # @param document [Object] the document object
  # @return [Boolean] true if the thumbnail should be rendered, false otherwise
  def thumb_to_render?(document)
    if document&.thumbnail&.file_url&.present? && document&.thumbnail&.file_derivatives&.present?
      true
    elsif document&.document_assets&.any?
      document.document_assets.any? do |asset|
        asset.file_derivatives&.key?(:thumb_standard_2X)
      end
    else
      false
    end
  end

  # Returns the URL of the thumbnail to render for a document.
  #
  # @param document [Object] the document object
  # @return [String] the URL of the thumbnail to render
  def thumbnail_to_render(document)
    if document&.thumbnail&.file_url&.present? && document&.thumbnail&.file_derivatives&.present?
      document.thumbnail.file_url(:thumb_standard_2X)
    elsif document&.document_assets&.any?
      document.document_assets.find do |asset|
        asset.file_derivatives&.key?(:thumb_standard_2X)
      end&.file_url(:thumb_standard_2X)
    end
  end
end

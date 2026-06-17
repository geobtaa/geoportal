# frozen_string_literal: true

# Solr indexing for our document class. Still a work in progress.
#
# The DocumentIndexer class is responsible for configuring how documents
# are indexed into Solr. It uses the Kithe::Indexer framework to map
# document attributes to Solr fields.
#
# The configuration block defines various fields that are indexed, including
# fields specific to GeoBlacklight and custom fields defined via the Element model.
#
# Fields:
# - model_pk_ssi: The primary key of the model, extracted from the object's ID.
# - gbl_mdVersion_s: A static version string for GeoBlacklight.
# - gbl_mdModified_dt: The modification date of the metadata.
# - date_created_dtsi: The creation date of the record, in UTC ISO8601 format.
# - date_modified_dtsi: The last modification date of the record, in UTC ISO8601 format.
# - b1g_geom_import_id_ssi: The import ID for GeoBlacklight administration.
#
# If the "elements" table exists, additional fields are indexed based on
# the Element model's configuration.
class DocumentIndexer < Kithe::Indexer
  def source_record_id_proc
    @source_record_id_proc ||= lambda do |source_record|
      next unless source_record

      [
        "Document.friendlier_id=#{source_record.try(:friendlier_id).presence || "(blank)"}",
        "Document.id=#{source_record.try(:id).presence || "(blank)"}",
        "geomg_id_s=#{source_record.respond_to?(:geomg_id_s) ? source_record.geomg_id_s.presence || "(blank)" : "(unavailable)"}",
        "publication_state=#{source_record.try(:publication_state).presence || "(blank)"}"
      ].join(" ")
    end
  end

  # Formats date/datetime values for Solr date fields (ISO8601 with time component)
  # Handles Date, DateTime, Time, String values, and arrays that look like Time#to_a results
  def self.format_date_for_solr(value, field_name = nil)
    return [] if value.blank?

    formatted_dates = []

    # Check if value is an array that looks like Time#to_a result [sec, min, hour, day, month, year, wday, yday, isdst, zone]
    # Time#to_a returns an array with 8-10 elements, all numeric except possibly the last (zone)
    if value.is_a?(Array) && value.length >= 8 && value.length <= 10 && value[0..6].all? { |v| v.is_a?(Numeric) }
      begin
        # Reconstruct Time from array: [sec, min, hour, day, month, year, wday, yday, isdst, zone]
        time_obj = Time.new(value[5], value[4], value[3], value[2], value[1], value[0])
        formatted_dates << time_obj.utc.iso8601
        return formatted_dates
      rescue ArgumentError => e
        Rails.logger.warn("Could not reconstruct Time from array: #{value.inspect} for field #{field_name}: #{e.message}") if field_name
        return []
      end
    end

    Array(value).each do |date_value|
      next if date_value.blank?

      if date_value.is_a?(Date) || date_value.is_a?(DateTime) || date_value.is_a?(Time)
        # Ensure we have a DateTime/Time object with time component
        dt = date_value.is_a?(Date) ? date_value.to_datetime : date_value
        formatted_dates << dt.utc.iso8601
      elsif date_value.is_a?(String)
        # Try to parse the string and convert to ISO8601
        begin
          parsed = Date.parse(date_value)
          formatted_dates << parsed.to_datetime.utc.iso8601
        rescue ArgumentError
          # If parsing fails, log warning and skip this value
          Rails.logger.warn("Could not parse date value: #{date_value} for field #{field_name}") if field_name
        end
      elsif field_name
        # Skip non-date values instead of adding them
        Rails.logger.warn("Unexpected date value type: #{date_value.class} (#{date_value.inspect}) for field #{field_name}")
      end
    end
    formatted_dates
  end

  configure do
    # Kithe
    to_field "model_pk_ssi", obj_extract("id") # the actual db pk, a UUID

    # GeoBlacklight
    to_field "gbl_mdVersion_s", literal("Aardvark")

    # to_field 'geomg_id_s', obj_extract('friendlier_id') # the actual db pk, a UUID

    # Define `to_field`(s) via Element
    if ActiveRecord::Base.connection.table_exists?("elements")
      Element.indexable.each do |elm|
        # Handle date/datetime fields specially - Solr requires ISO8601 format with time component
        if elm.field_type.in?(["date", "datetime"]) || elm.solr_field.end_with?("_dt")
          to_field elm.solr_field do |rec, acc|
            value = rec.send(elm.index_value)
            DocumentIndexer.format_date_for_solr(value, elm.solr_field).each { |formatted| acc << formatted }
          end
        else
          to_field elm.solr_field, obj_extract(elm.index_value)
        end
      end
    end

    to_field "gbl_mdModified_dt" do |rec, acc|
      value = rec.gbl_mdModified_dt
      DocumentIndexer.format_date_for_solr(value, "gbl_mdModified_dt").each { |formatted| acc << formatted }
    end

    # May want to switch to or add a 'date published' instead, right
    # now we only have date added to DB, which is what we had in sufia.
    to_field "date_created_dtsi" do |rec, _acc|
      rec&.created_at&.utc&.iso8601
    end

    to_field "date_modified_dtsi" do |rec, _acc|
      rec&.updated_at&.utc&.iso8601
    end

    # - GBL ADMIN
    to_field "b1g_geom_import_id_ssi", obj_extract("import_id")
  end
end

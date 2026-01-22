# frozen_string_literal: true

require "rgeo"
require "rgeo/wkrep/wkt_parser"

# GEOM Validation
#
# Uses local logic to parse and validate ENVELOPE values
# Uses RGeo to parse and validate POLYGON or MULTIPOLYGON values
class Document
  # GeomValidator
  class GeomValidator < ActiveModel::Validator
    def validate(record)
      # Assume true for empty values
      valid_geom = true

      if record.send(GeoblacklightAdmin::Schema.instance.solr_fields[:geometry]).present?
        valid_geom = if record.send(GeoblacklightAdmin::Schema.instance.solr_fields[:geometry]).start_with?("ENVELOPE")
          # Sane ENVELOPE?
          proper_envelope(record)
        else
          # Sane GEOM?
          proper_geom(record)
        end
      end

      valid_geom
    end

    # Validates ENVELOPE
    def proper_envelope(record)
      geom = record.send(GeoblacklightAdmin::Schema.instance.solr_fields[:geometry])
      begin
        valid_geom, error_message = valid_envelope?(geom.delete("ENVELOPE()"))
      rescue => e
        valid_geom = false
        record.errors.add(GeoblacklightAdmin::Schema.instance.solr_fields[:geometry], "Invalid envelope: #{e}")
      end

      unless valid_geom
        record.errors.add(GeoblacklightAdmin::Schema.instance.solr_fields[:geometry],
          "Invalid envelope: #{error_message}")
      end

      valid_geom
    end

    # Validates POLYGON and MULTIPOLYGON
    def proper_geom(record)
      geom = record.send(GeoblacklightAdmin::Schema.instance.solr_fields[:geometry])
      begin
        valid_geom = if RGeo::Cartesian::Factory.new.parse_wkt(geom)
          true
        else
          false
        end
      rescue => e
        valid_geom = false
        record.errors.add(GeoblacklightAdmin::Schema.instance.solr_fields[:geometry], "Invalid geometry: #{e}")
      end

      # Guard against a whole world polygons
      if geom == "POLYGON((-180 90, 180 90, 180 -90, -180 -90, -180 90))"
        valid_geom = false
        record.errors.add(GeoblacklightAdmin::Schema.instance.solr_fields[:geometry],
          "Invalid polygon: all points are coplanar input, Solr will not index")
      end

      # Guard against coplanar points
      if geom == "POLYGON((-180.0 90.0, 180.0 90.0, 180.0 -90.0, -180.0 -90.0, -180.0 90.0))"
        valid_geom = false
        record.errors.add(GeoblacklightAdmin::Schema.instance.solr_fields[:geometry],
          "Invalid polygon: all points are coplanar input, Solr will not index")
      end

      valid_geom
    end

    def valid_envelope?(envelope)
      # Default to true
      valid_envelope = true
      error_message = ""

      # Min/Max - W,E,N,S
      # ENVELOPE(-180,180,90,-90)
      min_max = [-180.0, 180.0, 90.0, -90.0]
      envelope = envelope.split(",")

      # Reject ENVELOPE(-118.00.0000,-88.00.0000,51.00.0000,42.00.0000)
      # - Double period float-ish things?
      envelope.each do |val|
        if val.count(".") >= 2
          valid_envelope = false
          error_message = "invalid ENVELOPE(W,E,N,S) syntax - found multiple periods in coordinate value(s)."
        end
      end

      # @TODO: Essentially duplicated logic from bbox_validator.rb, DRY it up
      if envelope.size != 4
        valid_envelope = false
        error_message = "invalid ENVELOPE(W,E,N,S) syntax"
      # W
      elsif envelope[0].to_f < min_max[0]
        valid_envelope = false
        error_message = "invalid minX present"
      # E
      elsif envelope[1].to_f > min_max[1]
        valid_envelope = false
        error_message = "invalid maX present"
      # N
      elsif envelope[2].to_f > min_max[2]
        valid_envelope = false
        error_message = "invalid maxY present"
      # S
      elsif envelope[3].to_f < min_max[3]
        valid_envelope = false
        error_message = "invalid minY present"
      # Solr - maxY must be >= minY
      elsif envelope[3].to_f >= envelope[2].to_f
        valid_envelope = false
        error_message = "maxY must be >= minY"
      end

      [valid_envelope, error_message]
    end
  end
end

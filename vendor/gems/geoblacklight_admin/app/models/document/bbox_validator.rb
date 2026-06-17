# frozen_string_literal: true

# Bbox Validation
#
# ex. Bad X value
# -100096.7909 is not in boundary
# Rect(minX=-180.0,maxX=180.0,minY=-90.0,maxY=90.0)
# input: ENVELOPE(-100096.7909,-90.0574,43.9474,39.9655)
class Document
  # BboxValidator
  class BboxValidator < ActiveModel::Validator
    def validate(record)
      bbox = record.send(GeoblacklightAdmin::Schema.instance.solr_fields[:bounding_box])

      # Assume true for empty values
      return true if bbox.blank?

      proper_bounding_box(record, bbox)
    end

    def proper_bounding_box(record, bbox)
      valid_geom = true
      field = GeoblacklightAdmin::Schema.instance.solr_fields[:bounding_box]

      # "W,S,E,N" to [W,S,E,N]
      geom = bbox.split(",").map(&:strip)

      if geom.empty?
        valid_geom = true
      elsif geom.size != 4
        valid_geom = false
        record.errors.add(field, "invalid W,S,E,N syntax")
      elsif geom.any? { |val| val.count(".") >= 2 }
        valid_geom = false
        record.errors.add(field,
          "invalid ENVELOPE(W,E,N,S) syntax - found multiple periods in a coordinate value.")
      else
        w, s, e, n = geom.map { |val| parse_coordinate(val) }

        if [w, s, e, n].any?(&:nil?)
          valid_geom = false
          record.errors.add(field, "invalid W,S,E,N syntax")
        elsif w < -180.0 || w > 180.0
          valid_geom = false
          record.errors.add(field, "invalid minX present")
        elsif s < -90.0 || s > 90.0
          valid_geom = false
          record.errors.add(field, "invalid minY present")
        elsif e < -180.0 || e > 180.0
          valid_geom = false
          record.errors.add(field, "invalid maxX present")
        elsif n < -90.0 || n > 90.0
          valid_geom = false
          record.errors.add(field, "invalid maxY present")
        elsif e <= w
          valid_geom = false
          record.errors.add(field, "maxX must be greater than minX")
        # Solr - maxY must be >= minY
        elsif s >= n
          valid_geom = false
          record.errors.add(field, "maxY must be >= minY")
        end
      end

      valid_geom
    end

    private

    def parse_coordinate(value)
      coordinate = Float(value)
      coordinate if coordinate.finite?
    rescue ArgumentError, TypeError
      nil
    end
  end
end

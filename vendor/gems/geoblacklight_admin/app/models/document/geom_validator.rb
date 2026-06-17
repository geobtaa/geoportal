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
    POLYGON_SOLR_ERROR = "Invalid polygon: all points are coplanar input, Solr will not index"
    GEOMETRY_BOUNDS_ERROR = "Invalid geometry: coordinates must be within longitude and latitude bounds for Solr indexing"

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
        return valid_geom
      end

      unless valid_geom
        record.errors.add(GeoblacklightAdmin::Schema.instance.solr_fields[:geometry],
          "Invalid envelope: #{error_message}")
      end

      valid_geom
    end

    # Validates POLYGON and MULTIPOLYGON
    def proper_geom(record)
      field = GeoblacklightAdmin::Schema.instance.solr_fields[:geometry]
      geom = record.send(GeoblacklightAdmin::Schema.instance.solr_fields[:geometry])

      begin
        parsed_geom = RGeo::Cartesian::Factory.new.parse_wkt(geom)
      rescue => e
        record.errors.add(field, "Invalid geometry: #{e}")
        return false
      end

      unless parsed_geom
        record.errors.add(field, "Invalid geometry")
        return false
      end

      solr_error = polygon_solr_error(parsed_geom)
      if solr_error.present?
        record.errors.add(field, solr_error)
        return false
      end

      true
    end

    def valid_envelope?(envelope)
      # Default to true
      valid_envelope = true
      error_message = ""

      envelope = envelope.split(",").map(&:strip)

      # @TODO: Essentially duplicated logic from bbox_validator.rb, DRY it up
      if envelope.size != 4
        valid_envelope = false
        error_message = "invalid ENVELOPE(W,E,N,S) syntax"
      # Reject ENVELOPE(-118.00.0000,-88.00.0000,51.00.0000,42.00.0000)
      # - Double period float-ish things?
      elsif envelope.any? { |val| val.count(".") >= 2 }
        valid_envelope = false
        error_message = "invalid ENVELOPE(W,E,N,S) syntax - found multiple periods in coordinate value(s)."
      elsif envelope.map { |val| parse_coordinate(val) }.any?(&:nil?)
        valid_envelope = false
        error_message = "invalid ENVELOPE(W,E,N,S) syntax"
      # W
      elsif envelope[0].to_f < -180.0 || envelope[0].to_f > 180.0
        valid_envelope = false
        error_message = "invalid minX present"
      # E
      elsif envelope[1].to_f < -180.0 || envelope[1].to_f > 180.0
        valid_envelope = false
        error_message = "invalid maxX present"
      # N
      elsif envelope[2].to_f < -90.0 || envelope[2].to_f > 90.0
        valid_envelope = false
        error_message = "invalid maxY present"
      # S
      elsif envelope[3].to_f < -90.0 || envelope[3].to_f > 90.0
        valid_envelope = false
        error_message = "invalid minY present"
      # Solr - maxX must be greater than minX
      elsif envelope[1].to_f <= envelope[0].to_f
        valid_envelope = false
        error_message = "maxX must be greater than minX"
      # Solr - maxY must be >= minY
      elsif envelope[3].to_f >= envelope[2].to_f
        valid_envelope = false
        error_message = "maxY must be >= minY"
      end

      [valid_envelope, error_message]
    end

    private

    def polygon_solr_error(geom)
      polygon_rings(geom).each do |ring|
        points = ring_points(ring)

        return GEOMETRY_BOUNDS_ERROR if points.any? { |x, y| out_of_bounds?(x, y) }
        return POLYGON_SOLR_ERROR if degenerate_ring?(points) || solr_coplanar_span?(points)
      end

      nil
    end

    def polygon_rings(geom)
      if RGeo::Feature::Polygon.check_type(geom)
        rings_for_polygon(geom)
      elsif RGeo::Feature::MultiPolygon.check_type(geom)
        (0...geom.num_geometries).flat_map { |i| rings_for_polygon(geom.geometry_n(i)) }
      else
        []
      end
    end

    def rings_for_polygon(polygon)
      rings = [polygon.exterior_ring]
      rings.concat((0...polygon.num_interior_rings).map { |i| polygon.interior_ring_n(i) })
    end

    def ring_points(ring)
      (0...ring.num_points).map do |i|
        point = ring.point_n(i)
        [point.x.to_f, point.y.to_f]
      end
    end

    def out_of_bounds?(x, y)
      x < -180.0 || x > 180.0 || y < -90.0 || y > 90.0
    end

    def degenerate_ring?(points)
      return true if points.size < 4
      return true if points.map(&:first).uniq.size < 2
      return true if points.map(&:last).uniq.size < 2

      polygon_area(points).zero?
    end

    def solr_coplanar_span?(points)
      xs = points.map(&:first)
      ys = points.map(&:last)

      (xs.max - xs.min) >= 180.0 || (ys.max - ys.min) >= 180.0
    end

    def polygon_area(points)
      points.each_cons(2).sum do |(x1, y1), (x2, y2)|
        (x1 * y2) - (x2 * y1)
      end.abs / 2.0
    end

    def parse_coordinate(value)
      coordinate = Float(value)
      coordinate if coordinate.finite?
    rescue ArgumentError, TypeError
      nil
    end
  end
end

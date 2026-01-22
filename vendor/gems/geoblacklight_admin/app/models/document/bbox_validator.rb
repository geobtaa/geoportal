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
      # Assume true for empty values
      valid_geom = true

      # Sane for W,S,E,N?
      unless record.send(GeoblacklightAdmin::Schema.instance.solr_fields[:bounding_box]).nil?
        proper_bounding_box(record,
          valid_geom)
      end

      valid_geom
    end

    def proper_bounding_box(record, valid_geom)
      # Min/Max
      min_max = [-180.0, -90.0, 180.0, 90.0]

      # "W,S,E,N" to [W,S,E,N]
      unless record.send(GeoblacklightAdmin::Schema.instance.solr_fields[:bounding_box]).split(",").nil?
        geom = record.send(GeoblacklightAdmin::Schema.instance.solr_fields[:bounding_box]).split(",")

        if geom.empty?
          valid_geom = true
        elsif geom.size != 4
          valid_geom = false
          record.errors.add(GeoblacklightAdmin::Schema.instance.solr_fields[:bounding_box], "invalid W,S,E,N syntax")
        # W
        elsif geom[0].to_f < min_max[0]
          valid_geom = false
          record.errors.add(GeoblacklightAdmin::Schema.instance.solr_fields[:bounding_box], "invalid minX present")
        # S
        elsif geom[1].to_f < min_max[1]
          valid_geom = false
          record.errors.add(GeoblacklightAdmin::Schema.instance.solr_fields[:bounding_box], "invalid minY present")
        # E
        elsif geom[2].to_f > min_max[2]
          valid_geom = false
          record.errors.add(GeoblacklightAdmin::Schema.instance.solr_fields[:bounding_box], "invalid maX present")
        # N
        elsif geom[3].to_f > min_max[3]
          valid_geom = false
          record.errors.add(GeoblacklightAdmin::Schema.instance.solr_fields[:bounding_box], "invalid maxY present")
        # Solr - maxY must be >= minY
        elsif geom[1].to_f >= geom[3].to_f
          valid_geom = false
          record.errors.add(GeoblacklightAdmin::Schema.instance.solr_fields[:bounding_box], "maxY must be >= minY")
        end

        # Reject ENVELOPE(-118.00.0000,-88.00.0000,51.00.0000,42.00.0000
        # - Double period float-ish things?
        geom.each do |val|
          next unless val.count(".") >= 2

          valid_geom = false
          record.errors.add(GeoblacklightAdmin::Schema.instance.solr_fields[:bounding_box],
            "invalid ENVELOPE(W,E,N,S) syntax - found multiple periods in a coordinate value.")
        end
      end

      valid_geom
    end
  end
end

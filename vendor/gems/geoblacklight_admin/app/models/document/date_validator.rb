# frozen_string_literal: true

# Date Validation
#
# ex. Bad date field type value
# "foo" is not a date
# "2023-12-5" is a date
class Document
  # DateValidator
  class DateValidator < ActiveModel::Validator
    def validate(record)
      # Assume true
      valid_date = true

      # Cache date elements to avoid repeated queries
      @date_elements ||= Element.where(field_type: "date").to_a

      # Sane date values?
      @date_elements.each do |element|
        value = record.send(element.solr_field)
        next if value.nil?

        Rails.logger.debug("Date Validator")
        Rails.logger.debug("Dates: #{value.inspect}")

        Array(value).each do |date|
          Rails.logger.debug("\nDate: #{date}")
          valid_date = proper_date(record, element, date, valid_date)
          break if !valid_date
        end
      end

      valid_date
    end

    def proper_date(record, element, date, valid_date)
      if date.blank?
        valid_date = true
      elsif date.class != Date
        valid_date = false
        record.errors.add(element.solr_field, "Bad date field type.")
      end

      Rails.logger.debug("#{date} - #{valid_date}")
      valid_date
    end
  end
end

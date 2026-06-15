# frozen_string_literal: true

# Date Range Validation
#
# Allow: YYYY-YYYY, *-YYYY, YYYY-*, Start YYYY == End YYYY
# Disallow: YYYX-YYYY, YYYY-, 2000-1999, YYYY-YYYY?
class Document
  # DateRangeValidator
  class DateRangeValidator < ActiveModel::Validator
    def validate(record)
      valid_date_ranges = true
      record.send(GeoblacklightAdmin::Schema.instance.solr_fields[:date_range]).each do |date_range|
        # Empty is fine
        if date_range.blank?
          valid_date_ranges = true
          return valid_date_ranges
        end

        # Must split into two via '-'
        if date_range.split("-").size != 2
          record.errors.add(GeoblacklightAdmin::Schema.instance.solr_fields[:date_range],
            "invalid date range present - missing YYYY-YYYY value")
          valid_date_ranges = false
          return valid_date_ranges
        end

        start_date, end_date = date_range.split("-")

        unless valid_yyyy(start_date)
          record.errors.add(GeoblacklightAdmin::Schema.instance.solr_fields[:date_range],
            "invalid start date - bad YYYY-YYYY value, only integers or the wildcard '*' allowed")
          valid_date_ranges = false
        end

        unless valid_yyyy(end_date)
          record.errors.add(GeoblacklightAdmin::Schema.instance.solr_fields[:date_range],
            "invalid end date - bad YYYY-YYYY value, only integers or the wildcard '*' allowed")
          valid_date_ranges = false
        end

        # Allow only 1 wildcard
        if start_date == "*" && end_date == "*"
          record.errors.add(GeoblacklightAdmin::Schema.instance.solr_fields[:date_range],
            "invalid only one wildcard can be used")
          valid_date_ranges = false
        end

        # Avoid 1996-1946
        next unless start_date[/\d+/] && end_date[/\d+/] && start_date.to_i > end_date.to_i

        record.errors.add(GeoblacklightAdmin::Schema.instance.solr_fields[:date_range],
          "invalid start date must be less than the end date")
        valid_date_ranges = false
      end
      valid_date_ranges
    end

    def valid_yyyy(date)
      if date[/\D/]
        false unless date == "*"
      else
        true
      end
    end
  end
end

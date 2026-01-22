# frozen_string_literal: true

##
# Module for GeoblacklightAdmin jobs.
module GeoblacklightAdmin
  ##
  # Job to remove an Element's attribute from all Document records' json_attributes.
  #
  # This job is queued with a priority level and is responsible for
  # removing a specific attribute key from the json_attributes JSONB column
  # of all Document records when an Element is destroyed.
  class RemoveElementAttributeJob < ApplicationJob
    queue_as :priority

    ##
    # Performs the job of removing the attribute from all Document records.
    #
    # Uses PostgreSQL JSONB operators to efficiently remove the key in a single
    # SQL query, only updating records where the key exists.
    #
    # @param solr_field [String] The solr_field value of the destroyed Element
    # @raise [StandardError] Logs an error if an exception occurs during the process.
    def perform(solr_field)
      return if solr_field.blank?

      # Use PostgreSQL JSONB subtraction operator to remove the key
      # Only update records where the key exists (using ? operator)
      updated_count = ActiveRecord::Base.connection.exec_update(
        <<-SQL.squish
          UPDATE kithe_models
          SET json_attributes = json_attributes - '#{ActiveRecord::Base.connection.quote_string(solr_field)}'
          WHERE type = 'Document'
            AND json_attributes ? '#{ActiveRecord::Base.connection.quote_string(solr_field)}'
        SQL
      )
      Rails.logger.info "Removed attribute '#{solr_field}' from #{updated_count} Document record(s)"
    rescue => e
      Rails.logger.error "Error removing attribute '#{solr_field}' from Document records: #{e.message}\n#{e.backtrace.join("\n")}"
      raise
    end
  end
end

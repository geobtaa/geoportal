# frozen_string_literal: true

require "csv"

# DestroyDocumentDistributionsJob
#
# This job processes a CSV file containing document distribution records to be destroyed.
# It handles large CSV files in the background to prevent timeouts and provides
# progress updates via notifications.
class DestroyDocumentDistributionsJob < ApplicationJob
  queue_as :priority

  def perform(file_path, current_user)
    logger.debug("DestroyDocumentDistributionsJob: Starting destruction of distributions from #{file_path}")

    destroyed_count = 0
    error_count = 0
    errors = []

    begin
      unless File.exist?(file_path)
        raise ArgumentError, "File not found: #{file_path}"
      end

      CSV.foreach(file_path, headers: true) do |row|
        logger.debug("Processing CSV Row: #{row.to_hash}")

        begin
          reference_type = ReferenceType.find_by(name: row.to_hash["reference_type"])

          if reference_type.nil?
            error_count += 1
            errors << "Reference type not found: #{row.to_hash["reference_type"]}"
            next
          end

          destroyed = DocumentDistribution.destroy_by(
            friendlier_id: row.to_hash["friendlier_id"],
            reference_type_id: reference_type.id,
            url: row.to_hash["distribution_url"]
          )

          if destroyed.any?
            destroyed_count += destroyed.count
            logger.debug("Destroyed: #{row.to_hash}")
          else
            logger.debug("Not found to destroy: #{row.to_hash}")
          end
        rescue => e
          error_count += 1
          errors << "Error processing row #{row.to_hash}: #{e.message}"
          logger.error("Error destroying distribution: #{e}")
        end
      end

      # Create success notification
      message = "DISTRIBUTIONS DESTROYED|#{ActionController::Base.helpers.number_with_delimiter(destroyed_count)} distributions destroyed"
      if error_count > 0
        message += " (#{error_count} errors)"
      end

      notification = ExportNotification.with(message: message)
      notification.deliver(current_user)

      # Clean up the temporary file
      File.delete(file_path) if File.exist?(file_path)

      logger.debug("DestroyDocumentDistributionsJob: Completed. Destroyed #{destroyed_count} distributions with #{error_count} errors")
    rescue => e
      logger.error("DestroyDocumentDistributionsJob: Fatal error - #{e}")

      # Create error notification
      notification = ExportNotification.with(message: "DISTRIBUTION DESTROY FAILED|Error: #{e.message}")
      notification.deliver(current_user)

      # Clean up the temporary file
      File.delete(file_path) if File.exist?(file_path)
    end
  end
end

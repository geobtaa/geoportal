# frozen_string_literal: true

require "csv"
require "zip"

# ExportTableauJob
class ExportTableauJob < ApplicationJob
  queue_as :priority

  def perform(current_user)
    logger.debug("\n\n Background Job: ♞")
    logger.debug("User: #{current_user.inspect}")
    logger.debug("Export Service: Tableau Export")
    logger.debug("\n\n")

    # Test broadcast
    ActionCable.server.broadcast("export_channel", {data: "Hello from Export Tableau Job!"})

    # Send progress
    file_content = ExportTableauService.call

    # Debug logging
    logger.debug("File content keys: #{file_content.keys}")
    logger.debug("Primary resources count: #{file_content[:primary_resources]&.size}")
    logger.debug("Distributions count: #{file_content[:distributions]&.size}")
    logger.debug("Primary resources sample: #{file_content[:primary_resources]&.first(2)}")
    logger.debug("Distributions sample: #{file_content[:distributions]&.first(2)}")
    
    # Also broadcast debug info
    ActionCable.server.broadcast("export_channel", {
      data: "Debug: File content keys: #{file_content.keys}",
      debug: {
        primary_count: file_content[:primary_resources]&.size,
        distributions_count: file_content[:distributions]&.size,
        primary_sample: file_content[:primary_resources]&.first(2),
        distributions_sample: file_content[:distributions]&.first(2)
      }
    })

    # Create ZIP file in public directory
    timestamp = Time.zone.now.strftime("%Y%m%d_%H%M%S")
    filename = "geomg-export-#{timestamp}.zip"
    zip_path = Rails.root.join("public", "exports", filename)
    
    # Ensure exports directory exists
    FileUtils.mkdir_p(Rails.root.join("public", "exports"))
    
    logger.debug("ZIP file path: #{zip_path}")
    
    # Create temporary CSV files first
    primary_csv_temp = Tempfile.new(["primary_resources", ".csv"])
    distributions_csv_temp = Tempfile.new(["distributions", ".csv"])
    
    # Write primary resources CSV
    CSV.open(primary_csv_temp.path, "wb") do |csv|
      file_content[:primary_resources].each do |row|
        csv << row
      end
    end
    
    # Write distributions CSV
    CSV.open(distributions_csv_temp.path, "wb") do |csv|
      file_content[:distributions].each do |row|
        csv << row
      end
    end
    
    logger.debug("Primary CSV size: #{File.size(primary_csv_temp.path)} bytes")
    logger.debug("Distributions CSV size: #{File.size(distributions_csv_temp.path)} bytes")
    
    # Create ZIP file
    Zip::File.open(zip_path, Zip::File::CREATE) do |zipfile|
      zipfile.add("primary_resources.csv", primary_csv_temp.path)
      zipfile.add("distributions.csv", distributions_csv_temp.path)
    end

    # Check ZIP file size
    logger.debug("ZIP file size: #{File.size(zip_path)} bytes")
    logger.debug("ZIP file exists: #{File.exist?(zip_path)}")
    
    # Broadcast file creation results
    ActionCable.server.broadcast("export_channel", {
      data: "File creation complete",
      file_info: {
        zip_size: File.size(zip_path),
        zip_exists: File.exist?(zip_path),
        primary_csv_size: File.size(primary_csv_temp.path),
        distributions_csv_size: File.size(distributions_csv_temp.path)
      }
    })
    
    # Clean up temp CSV files
    primary_csv_temp.close
    primary_csv_temp.unlink
    distributions_csv_temp.close
    distributions_csv_temp.unlink

    # Create notification
    # Message: "Download Type|Row Count|Button Label"
    primary_count = file_content[:primary_resources].size - 1
    distributions_count = file_content[:distributions].size - 1
    notification = ExportNotification.with(message: "ZIP (Tableau)|#{ActionController::Base.helpers.number_with_delimiter(primary_count)} primary, #{ActionController::Base.helpers.number_with_delimiter(distributions_count)} distributions|ZIP")

    # Deliver notification
    notification.deliver(current_user)

    # Send final progress with download URL
    download_url = "/exports/#{filename}"
    ActionCable.server.broadcast("export_channel", { 
      progress: 100,
      download_url: download_url
    })

    # Update UI
    ActionCable.server.broadcast("export_channel", {
      data: "Notification ready!",
      actions: [
        {
          method: "RefreshNotifications",
          payload: current_user.notifications.unread.count
        }
      ]
    })
  end
end

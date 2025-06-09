# frozen_string_literal: true

require "csv"

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

    # Calculate total steps (assuming each row is a step)
    total_steps = file_content.size
    current_step = 0

    # Write into tempfile
    @tempfile = Tempfile.new(["export-#{Time.zone.today}", ".csv"]).tap do |file|
      CSV.open(file, "wb") do |csv|
        file_content.each do |row|
          csv << row
          current_step += 1
          
          # Send progress update every 10 rows
          if current_step % 10 == 0
            progress = ((current_step.to_f / total_steps) * 100).round
            ActionCable.server.broadcast("export_channel", { progress: progress })
          end
        end
      end
    end

    # Create notification
    # Message: "Download Type|Row Count|Button Label"
    notification = ExportNotification.with(message: "CSV (Tableau)|#{ActionController::Base.helpers.number_with_delimiter(file_content.size - 1)} rows|CSV")

    # Deliver notification
    notification.deliver(current_user)

    # Attach CSV file (can only attach after persisted)
    notification.record.file.attach(io: @tempfile, filename: "geomg-export-#{Time.zone.today}.csv",
      content_type: "text/csv")

    # Send final progress with download URL
    ActionCable.server.broadcast("export_channel", { 
      progress: 100,
      download_url: Rails.application.routes.url_helpers.rails_blob_path(notification.record.file, only_path: true)
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

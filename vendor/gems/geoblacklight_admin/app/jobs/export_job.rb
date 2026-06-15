# frozen_string_literal: true

require "csv"
require "zip"

# ExportJob
class ExportJob < ApplicationJob
  queue_as :priority

  def perform(request, current_user, query_params, export_service)
    logger.debug("\n\n Background Job: ♞")
    logger.debug("Request: #{request.inspect}")
    logger.debug("User: #{current_user.inspect}")
    logger.debug("Query: #{query_params.inspect}")
    logger.debug("Export Service: #{export_service.inspect}")
    logger.debug("\n\n")

    # Test broadcast
    ActionCable.server.broadcast("export_channel", {data: "Hello from Export Job!"})

    # Query params into Doc ids
    document_ids = query_params[:ids] || crawl_query(request, query_params)

    logger.debug("Document Ids: #{document_ids}")

    # Send progress
    file_content_documents = export_service.call(document_ids)
    file_content_document_distributions = ExportCsvDocumentDistributionsService.call(document_ids)

    # Filename
    filename = export_service.short_name.parameterize(separator: "_")

    # Include Distributions?
    include_distributions = export_service&.include_distributions? || false

    # Write Documents into tempfile
    @tempfile_documents = Tempfile.new(["#{filename}-#{Time.zone.now.strftime("%Y-%m-%d-%H%M%S")}", ".csv"]).tap do |file|
      CSV.open(file, "wb") do |csv|
        file_content_documents.each do |row|
          csv << row
        end
      end
      logger.debug("Tempfile Documents Path: #{file.path}")
      logger.debug("Tempfile Documents Size: #{File.size(file.path)} bytes")
    end

    if include_distributions
      # Write DocumentDistributions into tempfile
      @tempfile_document_distributions = Tempfile.new(["distributions-#{Time.zone.now.strftime("%Y-%m-%d-%H%M%S")}", ".csv"]).tap do |file|
        CSV.open(file, "wb") do |csv|
          file_content_document_distributions.each do |row|
            csv << row
          end
        end
        logger.debug("Tempfile Document Distributions Path: #{file.path}")
        logger.debug("Tempfile Document Distributions Size: #{File.size(file.path)} bytes")
      end

      # Create a zip file containing both tempfiles
      zipfile_name = "export-#{filename}-#{Time.zone.now.strftime("%Y-%m-%d-%H%M%S")}.zip"
      tmp_dir = Rails.root.join("tmp")
      @tempfile_zip = Tempfile.new([zipfile_name, ".zip"], tmp_dir)

      Zip::File.open(@tempfile_zip.path, Zip::File::CREATE) do |zipfile|
        zipfile.add("#{filename}.csv", @tempfile_documents.path)
        zipfile.add("distributions.csv", @tempfile_document_distributions.path)
      end
      logger.debug("Zipfile Path: #{@tempfile_zip.path}")
      logger.debug("Zipfile Size: #{File.size(@tempfile_zip.path)} bytes")

      # Create notification
      notification = ExportNotification.with(message: "#{export_service.short_name}|#{ActionController::Base.helpers.number_with_delimiter(file_content_documents.size - 1)} rows|ZIP")
      notification.deliver(current_user)
      notification.record.file.attach(io: File.open(@tempfile_zip), filename: zipfile_name,
        content_type: "application/zip")
    else
      # Only primary CSV, attach directly
      csvfile_name = "#{filename}-#{Time.zone.now.strftime("%Y-%m-%d-%H%M%S")}.csv"
      notification = ExportNotification.with(message: "#{export_service.short_name}|#{ActionController::Base.helpers.number_with_delimiter(file_content_documents.size - 1)} rows|CSV")
      notification.deliver(current_user)
      notification.record.file.attach(io: File.open(@tempfile_documents), filename: csvfile_name,
        content_type: "text/csv")
    end

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

  def crawl_query(request, query_params, doc_ids = [])
    logger.debug("\n\n CRAWL Query: #{query_params}")
    logger.debug("\n\n CRAWL Query Request: #{request}")
    api_results = BlacklightApiIds.new(request, query_params)
    logger.debug("API Results: #{api_results.results.inspect}")

    doc_ids << api_results.results.pluck("id")

    unless api_results.meta["pages"]["next_page"].nil?
      crawl_query(request, query_params.merge!({page: api_results.meta["pages"]["next_page"]}),
        doc_ids)
    end

    doc_ids.flatten
  end
end

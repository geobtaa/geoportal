# frozen_string_literal: true

require "csv"

# ExportJsonBulkJob
class ExportJsonBulkJob < ApplicationJob
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
    documents = export_service.call(document_ids)

    begin
      # Array of JSON
      @json_array = []

      documents.each do |doc|
        json_output = Admin::DocumentsController.render("_json_file.jbuilder",
          locals: {document: doc})

        json_obj = JSON.parse(json_output)
        Rails.logger.debug json_obj

        # Remove nil/null values from JSON
        json_obj.compact!

        @json_array << JSON.pretty_generate(json_obj)
      rescue NoMethodError => e
        Rails.logger.debug { "==== Error! - #{doc.friendlier_id} ====" }
        Rails.logger.debug e.inspect
        next
      end
    end

    # Write into tempfile
    @tempfile = Tempfile.new(["export-#{Time.zone.today}", ".json"]).tap do |file|
      file.write("[#{@json_array.join(",")}]")
    end
    @tempfile.rewind

    # Create notification
    # Message: "Download Type|Row Count|Button Label"
    notification = ExportNotification.with(message: "JSON FILE |#{ActionController::Base.helpers.number_with_delimiter(documents.size)} rows|JSON")

    # Deliver notification
    notification.deliver(current_user)

    # Attach JSON file (can only attach after persisted)
    notification.record.file.attach(io: @tempfile, filename: "geomg-export-#{Time.zone.today}.json",
      content_type: "application/json")

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

# frozen_string_literal: true

require "json"
require "pathname"

# ExportJsonJob
class ExportJsonJob < ApplicationJob
  queue_as :priority

  def perform(request, current_user, query_params, export_service)
    logger.debug("\n\n Background Job: ♞")
    logger.debug("Request: #{request.inspect}")
    logger.debug("User: #{current_user.inspect}")
    logger.debug("Query: #{query_params.inspect}")
    logger.debug("Export Service: #{export_service.inspect}")
    logger.debug("\n\n")

    # Test broadcast
    ActionCable.server.broadcast("export_channel", {data: "Hello from Export JSON Job!"})

    # Query params into Doc ids
    document_ids = query_params[:ids] || crawl_query(request, query_params)

    # Rails.logger.debug("Document Ids: #{document_ids}")

    # Send progress
    documents = export_service.call(document_ids)

    # Write files into tempdir, zip together
    FileUtils.mkdir_p("ogm")

    Dir.mktmpdir do |dir|
      documents.each do |doc|
        # ===== Final Directory Structure =====
        # => Zip
        # ==> Provider
        # ===> Resource class (first)
        # ====> id.json

        Rails.logger.debug { "==== Query Format #{query_params[:format]} ====" }
        Rails.logger.debug { "==== Writing - #{doc.friendlier_id} - #{query_params[:format]} ====" }

        begin
          # File Path
          code = doc.b1g_code_s.presence || "_b1g_code_s_missing"
          resource_class = doc.gbl_resourceClass_sm.present? ? doc.gbl_resourceClass_sm.first : "_gbl_resourceClass_sm_missing"
          tree = Pathname("#{dir}/#{resource_class}/#{code}/#{doc.friendlier_id}.json")
          tree.dirname.mkpath
          Rails.logger.debug tree.inspect

          json_output = Admin::DocumentsController.render("_#{query_params[:format]}",
            locals: {document: doc})

          json_obj = JSON.parse(json_output)
          Rails.logger.debug json_obj

          # Remove nil/null values from JSON
          json_obj.compact!

          tree.write(JSON.pretty_generate(json_obj))
        rescue NoMethodError => e
          Rails.logger.debug { "==== Error! - #{doc.friendlier_id} ====" }
          Rails.logger.debug e.inspect
          next
        end
      end

      # ===== Local debugging =====
      # Sanity check dir
      # Rails.logger.debug '==== Dir GLOB - START ===='
      # Rails.logger.debug Dir.glob("#{dir}/*")
      # Rails.logger.debug '==== Dir GLOB - END ===='

      # Zip dir and attach
      @zip_file = Rails.root.join("tmp", "export-json-#{Time.zone.today}-#{SecureRandom.hex(8)}.zip")
      zf = ZipFileGenerator.new(dir, @zip_file)
      zf.write

      Rails.logger.debug { "File size: #{@zip_file.size}" }
    end

    # Create notification
    # Message: "Download Type|Row Count|Button Label"
    notification = ExportNotification.with(message: "#{query_params[:format].humanize.upcase}|#{ActionController::Base.helpers.number_with_delimiter(documents.size)} rows|ZIP")

    # Deliver notification
    notification.deliver(current_user)

    # Attach CSV file (can only attach after persisted)
    notification.record.file.attach(io: File.open(@zip_file), filename: "geomg-export-#{Time.zone.today}.zip",
      content_type: "application/zip")

    Rails.logger.debug "Notification File attached!"

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

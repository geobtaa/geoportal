# frozen_string_literal: true

# ImportRunJob class
class ImportRunJob < ApplicationJob
  queue_as :priority

  def perform(import)
    data = CSV.parse(import.csv_file.download, headers: true)

    data.each do |doc|
      extract_hash = doc.to_h

      converted_data = import.convert_data(extract_hash)

      # Set default publication state if not present
      unless converted_data["b1g_publication_state_s"].present?
        converted_data["b1g_publication_state_s"] = "draft"
      end

      kithe_document = {
        title: converted_data[GeoblacklightAdmin::Schema.instance.solr_fields[:title]],
        json_attributes: converted_data,
        friendlier_id: converted_data[GeoblacklightAdmin::Schema.instance.solr_fields[:id]],
        import_id: import.id
      }

      # Capture document for import attempt
      import_document = ImportDocument.create(kithe_document)

      # Add import document to background job queue
      ImportDocumentJob.perform_later(import_document)
    rescue => e
      logger.debug "\n\nCANNOT IMPORT: #{extract_hash.inspect}"
      logger.debug "Error: #{e.inspect}\n\n"
      next
    end
  end
end

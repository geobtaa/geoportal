# frozen_string_literal: true

require "json"

# ExportJsonService
class ExportJsonService
  def self.call(document_ids)
    ActionCable.server.broadcast("export_channel", {progress: 0})

    document_ids = document_ids.flatten
    total = document_ids.size
    count = 0
    slice_count = 100
    documents = []

    Rails.logger.debug { "\n\nExportJsonService: #{document_ids.inspect}\n\n" }

    document_ids.each_slice(slice_count) do |slice|
      # Broadcast progress percentage
      count += slice_count
      progress = ((count.to_f / total) * 100).round
      progress = 100 if progress > 100

      ActionCable.server.broadcast("export_channel", {progress: progress})
      slice.each do |doc_id|
        doc = Document.find_by(friendlier_id: doc_id)
        documents << doc
      rescue NoMethodError
        Rails.logger.debug { "\n\nExport Failed: #{doc_id.inspect}\n\n" }
      end
    end

    documents
  end
end

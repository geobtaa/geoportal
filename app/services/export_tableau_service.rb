# frozen_string_literal: true

# ExportTableauService
class ExportTableauService
  def self.call
    ActionCable.server.broadcast("export_channel", {progress: 0})

    total = Document.count
    count = 0
    slice_count = 1000
    csv_file = []

    Rails.logger.debug { "\n\nExportTableauService: #{total}\n\n" }

    csv_file << [
      "Title",
      "Provider",
      "Resource Class",
      "Resource Type",
      "Index Year",
      "Spatial Coverage",
      "B1G Image",
      "ID",
      "Download",
      "Language"
    ]

    Document.in_batches do |slice|
      # Broadcast progress percentage
      count += slice_count
      progress = ((count.to_f / total) * 100).round
      progress = 100 if progress > 100

      slice.each do |row|
        csv_file << [
            row.title,
            row.schema_provider_s,
            row.gbl_resourceClass_sm&.join("|"),
            row.gbl_resourceType_sm&.join("|"),
            row.gbl_indexYear_im&.join("|"),
            row.dct_spatial_sm&.join("|"),
            row.b1g_image_ss,
            row.geomg_id_s,
            row.dct_references_s.find { |ref| ref.category == "download" }&.value,
            row.dct_language_sm&.join("|")
          ]
      end

      ActionCable.server.broadcast("export_channel", {progress: progress})
    end

    csv_file
  end
end

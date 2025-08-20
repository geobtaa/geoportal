# frozen_string_literal: true

# ExportTableauService
class ExportTableauService
  def self.call
    ActionCable.server.broadcast("export_channel", {progress: 0})

    total = Document.count
    count = 0
    slice_count = 1000
    primary_csv = []
    distributions_csv = []

    Rails.logger.debug { "\n\nExportTableauService: #{total}\n\n" }

    # Primary resources CSV header
    primary_csv << [
      "Title",
      "Provider",
      "Resource Class",
      "Resource Type",
      "Index Year",
      "Spatial Coverage",
      "B1G Image",
      "ID",
      "Language"
    ]

    # Distributions CSV header
    distributions_csv << [
      "Document ID",
      "Document Title",
      "Distribution Type",
      "Distribution URL",
      "Distribution Label"
    ]

    Document.includes(:document_distributions).in_batches do |slice|
      # Broadcast progress percentage
      count += slice_count
      progress = ((count.to_f / total) * 100).round
      progress = 100 if progress > 100
      
      slice.each do |row|

        next unless row.publication_state == "published"

        # Primary resources row
        primary_csv << [
            row.title,
            row.schema_provider_s,
            row.gbl_resourceClass_sm&.join("|"),
            row.gbl_resourceType_sm&.join("|"),
            row.gbl_indexYear_im&.join("|"),
            row.dct_spatial_sm&.join("|"),
            row.b1g_image_ss,
            row.geomg_id_s,
            row.dct_language_sm&.join("|")
          ]

        # Distributions rows (one per distribution)
        row.document_distributions.each do |distribution|
          next unless distribution.reference_type&.name&.match?(/documentation_external|download/)
          
          distributions_csv << [
            row.geomg_id_s,
            row.title,
            distribution.reference_type&.name,
            distribution.url,
            distribution.label
          ]
        end
      end

      ActionCable.server.broadcast("export_channel", {progress: progress})
    end

    {
      primary_resources: primary_csv,
      distributions: distributions_csv
    }
  end
end

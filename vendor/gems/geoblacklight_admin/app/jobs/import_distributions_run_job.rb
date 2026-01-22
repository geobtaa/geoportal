# frozen_string_literal: true

# ImportDistributionsRunJob class
class ImportDistributionsRunJob < ApplicationJob
  queue_as :priority

  def perform(import)
    data = CSV.parse(import.csv_file.download, headers: true)

    data.each do |dist|
      extract_hash = dist.to_h

      document_distribution_hash = {
        friendlier_id: extract_hash["friendlier_id"],
        reference_type: extract_hash["reference_type"],
        distribution_url: extract_hash["distribution_url"],
        label: extract_hash["label"],
        import_distribution_id: import.id
      }

      # Capture document distribution for import attempt
      import_document_distribution = ImportDocumentDistribution.create(document_distribution_hash)

      # Add import document distribution to background job queue
      ImportDocumentDistributionJob.perform_later(import_document_distribution)
    rescue => e
      logger.debug "\n\nCANNOT IMPORT DISTRIBUTION: #{extract_hash.inspect}"
      logger.debug "Error: #{e.inspect}\n\n"
      next
    end
  end
end

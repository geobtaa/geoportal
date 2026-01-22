# frozen_string_literal: true

##
# Module for GeoblacklightAdmin jobs.
module GeoblacklightAdmin
  ##
  # Job to set the parent DCT references URI for a given asset.
  #
  # This job is responsible for creating a new reference for the asset's
  # DCT references URI key and appending it to the parent asset's
  # `dct_references_s` array. It then saves the parent asset.
  #
  # If an error occurs during the process, it logs the error message.
  class SetParentDctReferencesUriJob < ApplicationJob
    # Sets the queue for this job to :priority
    queue_as :priority

    ##
    # Performs the job to set the parent DCT references URI.
    #
    # @param asset [Object] The asset for which the DCT references URI is to be set.
    #
    # @return [void]
    def perform(asset)
      if asset.dct_references_uri_key.present?
        reference = Document::Reference.new
        reference.category = asset.dct_references_uri_key
        reference.value = asset.full_file_url
        asset.parent.dct_references_s << reference
        asset.parent.save!
      end
    rescue => e
      Rails.logger.error "\nError - Setting parent DCT references URI: #{e.message}\n"
    end
  end
end

# frozen_string_literal: true

##
# Module for GeoblacklightAdmin jobs.
module GeoblacklightAdmin
  ##
  # Job to remove a specific DCT references URI from the parent asset.
  #
  # This job is queued with a priority level and is responsible for
  # removing a DCT references URI from the parent of a given asset.
  class RemoveParentDctReferencesUriJob < ApplicationJob
    queue_as :priority

    ##
    # Performs the job of removing the DCT references URI from the parent asset.
    #
    # This method checks if the asset has a `dct_references_uri_key` present.
    # If present, it deletes the URI from the parent's `dct_references_s` array
    # if it matches the asset's full file URL, and then saves the parent asset.
    #
    # @param asset [Object] The asset whose parent's DCT references URI is to be removed.
    # @raise [StandardError] Logs an error if an exception occurs during the process.
    def perform(asset)
      if asset.dct_references_uri_key.present?
        asset.parent.dct_references_s.delete_if { |i| i.value == asset.full_file_url }
        asset.parent.save!
      end
    rescue => e
      Rails.logger.error "\nError - Removing parent dct_references URI: #{e.message} \n"
    end
  end
end

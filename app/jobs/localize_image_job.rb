# frozen_string_literal: true

class LocalizeImageJob < ApplicationJob
  queue_as :default

  def perform(document)
    begin
      GeoblacklightSidecarImages::ImageService.new(document).store
    rescue
      Rails.logger.debug("Failed to localize image - #{document}")
    end
  end
end

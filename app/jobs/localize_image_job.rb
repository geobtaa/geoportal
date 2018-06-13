# frozen_string_literal: true

class LocalizeImageJob < ApplicationJob
  queue_as :default

  def perform(url)
    url_hash = Digest::MD5.hexdigest(url)

    begin
      Down.download(
        url,
        :destination => Rails.root.join("public/uploads/localized/#{url_hash}")
      )

      FileUtils.chmod 0644, Rails.root.join("public/uploads/localized/#{url_hash}")
    rescue
      Rails.logger.debug("Failed to localize image - #{url}")
    end
  end
end

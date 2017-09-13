class PersistThumbnailJob < ActiveJob::Base
  queue_as :default

  def perform(options)
    PersistThumbnail.new(options).create_file
  end
end

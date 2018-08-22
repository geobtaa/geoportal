module ApplicationHelper
  def localized_image_path(url_hash)
    Rails.root.join("public/uploads/localized/#{url_hash}")
  end

  def remote_image_link(url)
    url_hash = Digest::MD5.hexdigest(url)
    if File.exist? localized_image_path(url_hash)
      geoportal_image_link = asset_url("uploads/localized/#{url_hash}")
    else
      external_image_link = url
      LocalizeImageJob.perform_later(url)
      external_image_link
    end
  end
end

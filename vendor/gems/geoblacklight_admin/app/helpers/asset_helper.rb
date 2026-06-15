# frozen_string_literal: true

# AssetHelper
#
# This module provides helper methods for asset management.
module AssetHelper
  # Determines if an asset has a thumbnail to render.
  #
  # @param asset [Object] The asset object to check.
  # @return [Boolean] Returns true if the asset has a file URL and file derivatives present, otherwise false.
  def asset_thumb_to_render?(asset)
    asset&.file_url&.present? && asset&.file_derivatives&.present?
  end
end

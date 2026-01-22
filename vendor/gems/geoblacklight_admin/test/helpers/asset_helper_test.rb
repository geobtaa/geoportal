# frozen_string_literal: true

require "test_helper"

class AssetHelperTest < ActionView::TestCase
  attr_reader :current_user

  setup do
    @asset = assets(:asset_1)
  end

  test "asset_thumb_to_render?" do
    assert asset_thumb_to_render?(@asset)
  end
end

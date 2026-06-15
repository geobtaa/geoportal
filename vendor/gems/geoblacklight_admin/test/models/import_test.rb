# frozen_string_literal: true

require "test_helper"

class ImportTest < ActiveSupport::TestCase
  def setup
    @import = Import.new
  end

  test "responds to run!" do
    assert_respond_to @import, :run!
  end
end

# frozen_string_literal: true

require "application_system_test_case"

class BookmarksTest < ApplicationSystemTestCase
  def setup
    sign_in_as users(:user_001)
  end

  test "visiting the index" do
    visit admin_bookmarks_url
    assert_selector "h1", text: "Bookmarks"
  end
end

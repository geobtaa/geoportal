# frozen_string_literal: true

require "test_helper"

class Admin::BookmarkTest < ActiveSupport::TestCase
  setup do
    @user = users(:user_001) # Assuming a user fixture or factory is available
    @document = documents(:ag) # Assuming a document fixture or factory is available
    @bookmark = Admin::Bookmark.new(user: @user, document: @document)
  end

  test "should be valid with valid attributes" do
    assert @bookmark.valid?
  end

  test "should require user_id" do
    @bookmark.user_id = nil
    assert_not @bookmark.valid?
    assert_includes @bookmark.errors[:user_id], "can't be blank"
  end

  test "should belong to a user" do
    assert_respond_to @bookmark, :user
    assert_instance_of User, @bookmark.user
  end

  test "should belong to a document" do
    assert_respond_to @bookmark, :document
    assert_instance_of Document, @bookmark.document
  end

  test "document_type should return Kithe::Model" do
    assert_equal Kithe::Model, @bookmark.document_type
  end

  test "document_id method should return the document's id" do
    assert_equal @document.id, @bookmark.document_id
  end
end

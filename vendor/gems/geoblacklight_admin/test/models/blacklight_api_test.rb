# frozen_string_literal: true

require "test_helper"

class BlacklightApiTest < ActiveSupport::TestCase
  def setup
    @blapi = BlacklightApi.new("http://localhost:3000", {})
  end

  test "Expects hash for arguments" do
    error = assert_raises(ArgumentError) { BlacklightApi.new("foo", "bar", "baz") }
    assert_equal error.message, "wrong number of arguments (given 3, expected 2)"
  end

  test "responds to fetch" do
    assert_respond_to @blapi, :fetch
  end

  test "responds to results" do
    assert_respond_to @blapi, :results
  end

  test "responds to facets" do
    assert_respond_to @blapi, :facets
  end

  test "responds to sorts" do
    assert_respond_to @blapi, :sorts
  end

  test "responds to meta" do
    assert_respond_to @blapi, :meta
  end

  test "responds to links" do
    assert_respond_to @blapi, :links
  end

  test "responds to load_all" do
    assert_respond_to @blapi, :load_all
  end
end

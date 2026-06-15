# frozen_string_literal: true

require "test_helper"

class Document::ReferenceTest < ActiveSupport::TestCase
  test "ref values are present" do
    assert_not_empty(Document::Reference::REFERENCE_VALUES)
  end
end

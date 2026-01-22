# frozen_string_literal: true

require "test_helper"

class Document::ControlledListsTest < ActiveSupport::TestCase
  test "lists are present" do
    assert_not_empty(Document::ControlledLists::ACCRUAL_PERIODICITY)
    assert_not_empty(Document::ControlledLists::B1G_STATUS)
    assert_not_empty(Document::ControlledLists::RESOURCE_CLASS)
    assert_not_empty(Document::ControlledLists::LAYER_GEOM_TYPES)
    assert_not_empty(Document::ControlledLists::ACCESS_RIGHTS)
    assert_not_empty(Document::ControlledLists::TYPE)
    assert_not_empty(Document::ControlledLists::PUBLICATION_STATE)
  end
end

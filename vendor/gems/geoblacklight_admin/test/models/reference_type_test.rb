require "test_helper"

class ReferenceTest < ActiveSupport::TestCase
  def setup
    @reference_type = ReferenceType.new(
      name: "Type1",
      reference_type: "Type1",
      reference_uri: "http://example.com"
    )
  end

  # Test validations
  test "should be valid with valid attributes" do
    assert @reference_type.valid?
  end

  test "should require a reference_type" do
    @reference_type.reference_type = nil
    assert_not @reference_type.valid?
  end

  test "should require a reference_uri" do
    @reference_type.reference_uri = nil
    assert_not @reference_type.valid?
  end

  test "should enforce uniqueness of reference_type" do
    duplicate_reference_type = @reference_type.dup
    @reference_type.save
    assert_not duplicate_reference_type.valid?
  end

  test "should enforce uniqueness of reference_uri" do
    duplicate_reference_type = @reference_type.dup
    @reference_type.save
    assert_not duplicate_reference_type.valid?
  end

  # Test callbacks
  test "should set position before create" do
    @reference_type.save
    assert_not_nil @reference_type.position
  end

  # Test class methods
  test "should sort elements based on id array" do
    ref1 = ReferenceType.create(name: "Type1", reference_type: "Type1", reference_uri: "http://example1.com")
    ref2 = ReferenceType.create(name: "Type2", reference_type: "Type2", reference_uri: "http://example2.com")
    ref3 = ReferenceType.create(name: "Type3", reference_type: "Type3", reference_uri: "http://example3.com")

    ReferenceType.sort_elements([ref3.id, ref1.id, ref2.id])

    assert_equal 0, ref3.reload.position
    assert_equal 1, ref1.reload.position
    assert_equal 2, ref2.reload.position
  end
end

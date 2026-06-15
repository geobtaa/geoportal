# frozen_string_literal: true

class DocumentLicensedAccessTest < ActiveSupport::TestCase
  setup do
    @document_licensed_access = DocumentLicensedAccess.new
  end

  test "should be valid with required attributes" do
    document = documents(:ag)
    @document_licensed_access.friendlier_id = document.friendlier_id
    @document_licensed_access.institution_code = "01"
    @document_licensed_access.access_url = "https://example.com"
    assert @document_licensed_access.valid?
  end

  test "should not be valid without institution_code" do
    @document_licensed_access.institution_code = nil
    refute @document_licensed_access.valid?
    assert_not_nil @document_licensed_access.errors[:institution_code]
  end

  test "should not be valid without access_url" do
    @document_licensed_access.access_url = nil
    refute @document_licensed_access.valid?
    assert_not_nil @document_licensed_access.errors[:access_url]
  end

  test "should not be valid with invalid access_url" do
    @document_licensed_access.access_url = "not-a-url"
    refute @document_licensed_access.valid?
    assert_not_nil @document_licensed_access.errors[:access_url]
  end

  test "should enforce unique institution_code per document" do
    existing = document_licensed_accesses(:one)
    @document_licensed_access.friendlier_id = existing.friendlier_id
    @document_licensed_access.institution_code = existing.institution_code
    @document_licensed_access.access_url = "https://example.com"
    refute @document_licensed_access.valid?
    assert_not_nil @document_licensed_access.errors[:institution_code]
  end

  test "should respond to import" do
    assert_respond_to DocumentLicensedAccess, :import
  end
end

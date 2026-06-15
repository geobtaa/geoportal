require "test_helper"

class BulkActionTest < ActiveSupport::TestCase
  def setup
    @bulk_action = BulkAction.new
  end

  test "creates a bulk action" do
    skip("@TODO: Bulk Action fixture missing")

    @bulk_action.request = "https://localhost:3000"
    @bulk_action.scope = "%2Fdocuments%2Ffetch%3Fids%255B%255D%3D0dd569b5-cb64-4a9e-8ae1-e95a3382ec42%26ids%255B%255D%3Ddc6cafc7-403f-4358-92ab-b509739aa9b6"
    @bulk_action.field_name = "Publication State"
    @bulk_action.field_value = "unpublished"

    assert_nothing_raised do
      @bulk_action.save
    end
  end
end

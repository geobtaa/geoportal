require "test_helper"

class BulkActionRunJobTest < ActiveJob::TestCase
  def setup
    @bulk_action = bulk_actions(:one)
    @response = BulkActionRunJob.perform_later(@bulk_action)
  end

  test "enqueued jobs" do
    assert_enqueued_jobs 1
    clear_enqueued_jobs
    assert_enqueued_jobs 0
  end

  test "should update publication status" do
    @bulk_action.field_name = "Publication State"
    BulkActionRunJob.perform_now(@bulk_action)
  end

  test "should delete" do
    @bulk_action.field_name = "Delete"
    BulkActionRunJob.perform_now(@bulk_action)
  end

  test "should harvest thumbnails" do
    @bulk_action.field_name = "Harvest Thumbnails"
    BulkActionRunJob.perform_now(@bulk_action)
  end

  test "should delete thumbnails" do
    @bulk_action.field_name = "Delete Thumbnails"
    BulkActionRunJob.perform_now(@bulk_action)
  end

  test "should update field value" do
    @bulk_action.field_name = "Some Other Field"
    BulkActionRunJob.perform_now(@bulk_action)
  end
end

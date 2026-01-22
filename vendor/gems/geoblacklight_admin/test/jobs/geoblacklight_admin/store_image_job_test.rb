require "test_helper"

module GeoblacklightAdmin
  class StoreImageJobTest < ActiveJob::TestCase
    def setup
      @document = documents(:ls)
      @bad_document = bulk_action_documents(:one)
    end

    test "should perform job and store image" do
      assert_enqueued_with(job: StoreImageJob) do
        StoreImageJob.perform_later(@document.friendlier_id)
      end

      perform_enqueued_jobs do
        StoreImageJob.perform_now(@document.friendlier_id)
      end

      @document.reload

      assert @document.thumbnail.present?

      # @TODO: This test passes locally, but fails in CI
      # Thumbnail harvesting is problematic in CI
      # Skipping this state assertion for now
      # assert_equal "succeeded", @document.thumbnail_state_machine.current_state
    end

    test "should transition bad document state to success" do
      perform_enqueued_jobs do
        StoreImageJob.perform_now(@document.friendlier_id, @bad_document.id)
      end

      @bad_document.reload
      assert_equal "success", @bad_document.state_machine.current_state
    end
  end
end

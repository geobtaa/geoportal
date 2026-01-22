require "test_helper"

module GeoblacklightAdmin
  class DeleteThumbnailJobTest < ActiveJob::TestCase
    def setup
      @document = documents(:ls)
      @bad_document = bulk_action_documents(:one)
    end

    test "should delete thumbnail if present" do
      StoreImageJob.expects(:perform_now).with(@document.friendlier_id)
      DeleteThumbnailJob.expects(:perform_now).with(@document.friendlier_id)

      perform_enqueued_jobs do
        StoreImageJob.perform_now(@document.friendlier_id)
      end

      perform_enqueued_jobs do
        DeleteThumbnailJob.perform_now(@document.friendlier_id)
      end

      @document.reload
      assert_nil @document.thumbnail
    end
  end
end

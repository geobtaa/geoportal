# frozen_string_literal: true

require "test_helper"

class BulkActionRunDocumentJobTest < ActiveJob::TestCase
  def setup
    @document = documents(:ag)
    @job = BulkActionRunDocumentJob.new
  end

  def test_perform_update_publication_status_to_published
    @document.update!(publication_state: "draft")
    assert_changes -> { @document.reload.publication_state }, from: "draft", to: "published" do
      @job.perform(:update_publication_status, @document, nil, "publish")
    end
  end

  def test_perform_update_publication_status_to_unpublished
    @document.update!(publication_state: "published")
    assert_changes -> { @document.reload.publication_state }, from: "published", to: "unpublished" do
      @job.perform(:update_publication_status, @document, nil, "unpublish")
    end
  end

  def test_perform_update_publication_status_to_draft
    @document.update!(publication_state: "published")
    assert_changes -> { @document.reload.publication_state }, from: "published", to: "draft" do
      @job.perform(:update_publication_status, @document, nil, "set as draft")
    end
  end

  def test_perform_update_delete
    assert_difference "Document.count", -1 do
      @job.perform(:update_delete, @document, nil, true)
    end
  end

  def test_perform_harvest_thumbnails
    assert_enqueued_with(job: GeoblacklightAdmin::StoreImageJob, args: [@document.friendlier_id, @document.id, :priority]) do
      @job.perform(:harvest_thumbnails, @document, nil, nil)
    end
  end

  def test_perform_delete_thumbnails
    assert_enqueued_with(job: GeoblacklightAdmin::DeleteThumbnailJob, args: [@document.friendlier_id, @document.id, :priority]) do
      @job.perform(:delete_thumbnails, @document, nil, nil)
    end
  end
end

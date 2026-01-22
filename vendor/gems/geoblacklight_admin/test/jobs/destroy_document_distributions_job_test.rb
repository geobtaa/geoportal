require "test_helper"

class DestroyDocumentDistributionsJobTest < ActiveJob::TestCase
  setup do
    @current_user = users(:user_001)
    @document = documents(:ls)
    @reference_type = ReferenceType.first

    # Create some test document distributions
    @distribution1 = DocumentDistribution.create!(
      friendlier_id: @document.friendlier_id,
      reference_type: @reference_type,
      url: "https://example.com/file1.zip",
      label: "Test File 1"
    )

    @distribution2 = DocumentDistribution.create!(
      friendlier_id: @document.friendlier_id,
      reference_type: @reference_type,
      url: "https://example.com/file2.zip",
      label: "Test File 2"
    )

    # Create a temporary CSV file for testing
    @temp_file = Tempfile.new(["test_destroy", ".csv"])
    CSV.open(@temp_file.path, "wb") do |csv|
      csv << ["friendlier_id", "reference_type", "distribution_url", "label"]
      csv << [@document.friendlier_id, @reference_type.name, @distribution1.url, @distribution1.label]
      csv << [@document.friendlier_id, @reference_type.name, @distribution2.url, @distribution2.label]
    end
  end

  teardown do
    @temp_file.close
    @temp_file.unlink
  end

  test "job is enqueued" do
    assert_enqueued_with(job: DestroyDocumentDistributionsJob) do
      DestroyDocumentDistributionsJob.perform_later(@temp_file.path, @current_user)
    end
  end

  test "job destroys distributions from CSV file" do
    assert_difference "DocumentDistribution.count", -2 do
      perform_enqueued_jobs do
        DestroyDocumentDistributionsJob.perform_later(@temp_file.path, @current_user)
      end
    end
  end

  test "job creates notification when complete" do
    perform_enqueued_jobs do
      DestroyDocumentDistributionsJob.perform_later(@temp_file.path, @current_user)
    end

    assert @current_user.notifications.any?
    notification = @current_user.notifications.last
    assert_includes notification.to_notification.params[:message], "DISTRIBUTIONS DESTROYED"
    assert_includes notification.to_notification.params[:message], "2 distributions destroyed"
  end

  test "job handles missing reference type gracefully" do
    # Create CSV with invalid reference type
    invalid_csv = Tempfile.new(["invalid", ".csv"])
    CSV.open(invalid_csv.path, "wb") do |csv|
      csv << ["friendlier_id", "reference_type", "distribution_url", "label"]
      csv << [@document.friendlier_id, "invalid_type", "https://example.com/invalid.zip", "Invalid"]
    end

    assert_no_difference "DocumentDistribution.count" do
      perform_enqueued_jobs do
        DestroyDocumentDistributionsJob.perform_later(invalid_csv.path, @current_user)
      end
    end

    # Should still create notification with error count
    notification = @current_user.notifications.last
    assert_includes notification.to_notification.params[:message], "0 distributions destroyed"
    assert_includes notification.to_notification.params[:message], "(1 errors)"

    invalid_csv.close
    invalid_csv.unlink
  end

  test "job cleans up temporary file after completion" do
    temp_file_path = @temp_file.path

    perform_enqueued_jobs do
      DestroyDocumentDistributionsJob.perform_later(temp_file_path, @current_user)
    end

    # File should be deleted
    assert_not File.exist?(temp_file_path)
  end

  test "job handles file not found gracefully" do
    non_existent_file = "/tmp/non_existent_file.csv"

    perform_enqueued_jobs do
      DestroyDocumentDistributionsJob.perform_later(non_existent_file, @current_user)
    end

    # Should create error notification
    notification = @current_user.notifications.last
    assert_includes notification.to_notification.params[:message], "DISTRIBUTION DESTROY FAILED"
    assert_includes notification.to_notification.params[:message], "File not found"
  end
end

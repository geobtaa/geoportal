# frozen_string_literal: true

require "test_helper"

class ImportDistributionsRunJobTest < ActiveJob::TestCase
  setup do
    @import_distribution = import_distributions(:one)

    @import_distribution.csv_file = ActiveStorage::Blob.find_signed(active_storage_blobs(:import_distribution_blob).signed_id)
  end

  test "should create ImportDocuments for each CSV row" do
    # Perform the job
    perform_enqueued_jobs do
      ImportDistributionsRunJob.perform_now(@import_distribution)
    end

    assert_equal 16, ImportDocumentDistribution.count
    assert ImportDocumentDistribution.exists?(friendlier_id: "p16022coll230:4115")
  end

  test "should handle CSV parsing errors gracefully" do
    # Adjust the CSV content to simulate an error
    @import_distribution.csv_file.define_singleton_method(:download) { "title,id\nInvalid row" }

    # Perform the job with the erroneous content
    assert_nothing_raised do
      perform_enqueued_jobs do
        ImportDistributionsRunJob.perform_now(@import_distribution)
      end
    end

    # Ensure no new ImportDocuments were created (1 already exists from fixture)
    assert_equal 1, ImportDocumentDistribution.count
  end

  test "logs errors without stopping the job" do
    skip("TODO: these all error because they need the btaa_sample_records.csv file to be imported first")
    # Stub convert_data to raise an error
    def @import_distribution.convert_data(_)
      raise "Simulated error"
    end

    # Perform the job and check that it handles the error
    assert_nothing_raised do
      perform_enqueued_jobs do
        ImportDistributionsRunJob.perform_now(@import_distribution)
      end
    end

    # No new ImportDocumentDistributions should be created due to the error (1 already exists from fixture)
    assert_equal 1, ImportDocumentDistribution.count
  end
end

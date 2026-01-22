# frozen_string_literal: true

require "test_helper"

class ImportRunJobTest < ActiveJob::TestCase
  setup do
    @import = imports(:one)

    @import.csv_file = ActiveStorage::Blob.find_signed(active_storage_blobs(:import_btaa_blob).signed_id)
  end

  test "should create ImportDocuments for each CSV row" do
    # Perform the job
    perform_enqueued_jobs do
      ImportRunJob.perform_now(@import)
    end

    assert_equal 5, ImportDocument.count
    assert ImportDocument.exists?(friendlier_id: "p16022coll230:4115")
  end

  test "should handle CSV parsing errors gracefully" do
    # Adjust the CSV content to simulate an error
    @import.csv_file.define_singleton_method(:download) { "title,id\nInvalid row" }

    # Perform the job with the erroneous content
    assert_nothing_raised do
      perform_enqueued_jobs do
        ImportRunJob.perform_now(@import)
      end
    end

    # Ensure no new ImportDocuments were created (1 already exists from fixture)
    assert_equal 1, ImportDocument.count
  end

  test "logs errors without stopping the job" do
    # Stub convert_data to raise an error
    def @import.convert_data(_)
      raise "Simulated error"
    end

    # Perform the job and check that it handles the error
    assert_nothing_raised do
      perform_enqueued_jobs do
        ImportRunJob.perform_now(@import)
      end
    end

    # No new ImportDocuments should be created due to the error (1 already exists from fixture)
    assert_equal 1, ImportDocument.count
  end
end

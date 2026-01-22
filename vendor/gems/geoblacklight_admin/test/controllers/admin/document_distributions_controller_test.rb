require "test_helper"

class Admin::DocumentDistributionsControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  setup do
    @user = users(:user_001)
    sign_in @user
  end

  test "destroy_all queues background job" do
    # Create a temporary CSV file for testing
    csv_content = "friendlier_id,reference_type,distribution_url,label\n"
    csv_content += "test-id,download,https://example.com/test.zip,Test File"

    temp_file = Tempfile.new(["test_destroy", ".csv"])
    temp_file.write(csv_content)
    temp_file.rewind

    assert_enqueued_with(job: DestroyDocumentDistributionsJob) do
      post destroy_all_admin_document_distributions_path, params: {
        document_distribution: {
          distributions: {
            file: fixture_file_upload(temp_file.path, "text/csv")
          }
        }
      }
    end

    assert_redirected_to admin_document_distributions_path
    assert_equal "Distribution destruction job has been queued. You will receive a notification when it completes.", flash[:notice]

    temp_file.close
    temp_file.unlink
  end

  test "destroy_all handles missing file gracefully" do
    post destroy_all_admin_document_distributions_path, params: {
      document_distribution: {
        distributions: {}
      }
    }

    assert_redirected_to admin_document_distributions_path
    assert_includes flash[:notice], "Failed to queue distribution destruction job"
  end
end

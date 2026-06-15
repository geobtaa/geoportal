require "test_helper"

class ExportJobTest < ActiveJob::TestCase
  setup do
    @request = "http://localhost:3000"
    @current_user = users(:user_001) # Assuming you have a fixture for users
    @query_params = {ids: [1, 2, 3]}
    @export_service = ExportCsvService
  end

  test "job is enqueued" do
    assert_enqueued_with(job: ExportJob) do
      ExportJob.perform_later(@request, @current_user, @query_params, @export_service)
    end
  end

  test "job is performed" do
    perform_enqueued_jobs do
      ExportJob.perform_later(@request, @current_user, @query_params, @export_service)
    end

    # Add assertions to verify the expected behavior
    # For example, check if the notification was delivered
    assert @current_user.notifications.any?
  end
end

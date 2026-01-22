# frozen_string_literal: true

require "test_helper"

class ExportJsonBulkJobTest < ActiveJob::TestCase
  def setup
    @document = documents(:ag)
    @user = users(:user_001)
    @request = mock
    @query_params = {ids: [@document.id]}
    @export_service = mock
    @job = ExportJsonBulkJob.new

    # Mock ActionCable server
    ActionCable.server.stubs(:broadcast).returns(true)

    # Mock ActiveStorage attachment
    @mock_attachment = mock
    @mock_attachment.stubs(:attach).returns(true)
  end

  def test_perform_with_direct_ids
    mock_json_output = '{"id": "test-id", "title": "Test Document"}'
    mock_documents = [@document]

    @export_service.expects(:call).with([@document.id]).returns(mock_documents)
    Admin::DocumentsController.expects(:render)
      .with("_json_file.jbuilder", locals: {document: @document})
      .returns(mock_json_output)

    notification = mock
    notification.stubs(:record).returns(notification)
    notification.stubs(:file).returns(@mock_attachment)
    notification.expects(:deliver).with(@user)

    ExportNotification.expects(:with)
      .with(message: "JSON FILE |1 rows|JSON")
      .returns(notification)

    ActionCable.server.expects(:broadcast)
      .with("export_channel", {data: "Hello from Export Job!"})

    ActionCable.server.expects(:broadcast)
      .with("export_channel", {
        data: "Notification ready!",
        actions: [{method: "RefreshNotifications", payload: @user.notifications.unread.count}]
      })

    @job.perform(@request, @user, @query_params, @export_service)
  end

  def test_perform_with_query_crawl
    mock_json_output = '{"id": "test-id", "title": "Test Document"}'
    mock_documents = [@document]
    query_params = {q: "test"}

    mock_api_results = mock
    mock_api_results.stubs(:results).returns([{"id" => @document.id}])
    mock_api_results.stubs(:meta).returns({"pages" => {"next_page" => nil}})

    BlacklightApiIds.expects(:new)
      .with(@request, query_params)
      .returns(mock_api_results)

    @export_service.expects(:call).with([@document.id]).returns(mock_documents)
    Admin::DocumentsController.expects(:render)
      .with("_json_file.jbuilder", locals: {document: @document})
      .returns(mock_json_output)

    notification = mock
    notification.stubs(:record).returns(notification)
    notification.stubs(:file).returns(@mock_attachment)
    notification.expects(:deliver).with(@user)

    ExportNotification.expects(:with)
      .with(message: "JSON FILE |1 rows|JSON")
      .returns(notification)

    ActionCable.server.expects(:broadcast)
      .with("export_channel", {data: "Hello from Export Job!"})

    ActionCable.server.expects(:broadcast)
      .with("export_channel", {
        data: "Notification ready!",
        actions: [{method: "RefreshNotifications", payload: @user.notifications.unread.count}]
      })

    @job.perform(@request, @user, query_params, @export_service)
  end

  def test_perform_with_pagination
    mock_json_output = '{"id": "test-id", "title": "Test Document"}'
    mock_documents = [@document]
    query_params = {q: "test"}

    # First page results
    mock_api_results1 = mock
    mock_api_results1.stubs(:results).returns([{"id" => @document.id}])
    mock_api_results1.stubs(:meta).returns({"pages" => {"next_page" => 2}})

    # Second page results
    mock_api_results2 = mock
    mock_api_results2.stubs(:results).returns([{"id" => @document.id}])
    mock_api_results2.stubs(:meta).returns({"pages" => {"next_page" => nil}})

    BlacklightApiIds.expects(:new)
      .with(@request, query_params)
      .returns(mock_api_results1)

    BlacklightApiIds.expects(:new)
      .with(@request, query_params.merge(page: 2))
      .returns(mock_api_results2)

    @export_service.expects(:call).with([@document.id, @document.id]).returns(mock_documents)
    Admin::DocumentsController.expects(:render)
      .with("_json_file.jbuilder", locals: {document: @document})
      .returns(mock_json_output)

    notification = mock
    notification.stubs(:record).returns(notification)
    notification.stubs(:file).returns(@mock_attachment)
    notification.expects(:deliver).with(@user)

    ExportNotification.expects(:with)
      .with(message: "JSON FILE |1 rows|JSON")
      .returns(notification)

    ActionCable.server.expects(:broadcast)
      .with("export_channel", {data: "Hello from Export Job!"})

    ActionCable.server.expects(:broadcast)
      .with("export_channel", {
        data: "Notification ready!",
        actions: [{method: "RefreshNotifications", payload: @user.notifications.unread.count}]
      })

    @job.perform(@request, @user, query_params, @export_service)
  end

  def test_perform_handles_no_method_error
    mock_documents = [@document]
    @export_service.expects(:call).with([@document.id]).returns(mock_documents)

    # Simulate a NoMethodError when trying to render the document
    Admin::DocumentsController.expects(:render)
      .with("_json_file.jbuilder", locals: {document: @document})
      .raises(NoMethodError.new("undefined method"))

    notification = mock
    notification.stubs(:record).returns(notification)
    notification.stubs(:file).returns(@mock_attachment)
    notification.expects(:deliver).with(@user)

    ExportNotification.expects(:with)
      .with(message: "JSON FILE |1 rows|JSON")
      .returns(notification)

    ActionCable.server.expects(:broadcast)
      .with("export_channel", {data: "Hello from Export Job!"})

    ActionCable.server.expects(:broadcast)
      .with("export_channel", {
        data: "Notification ready!",
        actions: [{method: "RefreshNotifications", payload: @user.notifications.unread.count}]
      })

    assert_nothing_raised do
      @job.perform(@request, @user, @query_params, @export_service)
    end
  end

  def test_perform_broadcasts_progress
    mock_documents = [@document]
    @export_service.expects(:call).with([@document.id]).returns(mock_documents)
    Admin::DocumentsController.expects(:render)
      .with("_json_file.jbuilder", locals: {document: @document})
      .returns('{"id": "test-id"}')

    notification = mock
    notification.stubs(:record).returns(notification)
    notification.stubs(:file).returns(@mock_attachment)
    notification.expects(:deliver).with(@user)

    ExportNotification.expects(:with)
      .with(message: "JSON FILE |1 rows|JSON")
      .returns(notification)

    ActionCable.server.expects(:broadcast)
      .with("export_channel", {data: "Hello from Export Job!"})

    ActionCable.server.expects(:broadcast)
      .with("export_channel", {
        data: "Notification ready!",
        actions: [{method: "RefreshNotifications", payload: @user.notifications.unread.count}]
      })

    @job.perform(@request, @user, @query_params, @export_service)
  end

  def test_perform_creates_notification_with_correct_message
    mock_documents = [@document]
    @export_service.expects(:call).with([@document.id]).returns(mock_documents)
    Admin::DocumentsController.expects(:render)
      .with("_json_file.jbuilder", locals: {document: @document})
      .returns('{"id": "test-id"}')

    notification = mock
    notification.stubs(:record).returns(notification)
    notification.stubs(:file).returns(@mock_attachment)
    notification.expects(:deliver).with(@user)

    ExportNotification.expects(:with)
      .with(message: "JSON FILE |1 rows|JSON")
      .returns(notification)

    ActionCable.server.expects(:broadcast)
      .with("export_channel", {data: "Hello from Export Job!"})

    ActionCable.server.expects(:broadcast)
      .with("export_channel", {
        data: "Notification ready!",
        actions: [{method: "RefreshNotifications", payload: @user.notifications.unread.count}]
      })

    @job.perform(@request, @user, @query_params, @export_service)
  end
end

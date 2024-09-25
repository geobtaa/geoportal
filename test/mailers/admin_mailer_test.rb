require 'test_helper'

class AdminMailerTest < ActionMailer::TestCase
  def setup
    ActionMailer::Base.default_options = { from: 'noreply@example.com' }
  end

  test "image_states" do
    rake_results = {
      "Institution A" => { success: 10, failure: 2 },
      "Institution B" => { success: 15, failure: 0 }
    }
    
    email = AdminMailer.image_states(rake_results)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ['geoportal@btaa.org', 'majew030@umn.edu', 'ewlarson@gmail.com', 'mjb@umn.edu'], email.to
    assert_equal 'noreply@example.com', email.from[0]
    assert_equal 'B1G GeoBOT - Image Harvest States', email.subject
    assert_match 'Institution A', email.body.to_s
    assert_match 'Institution B', email.body.to_s
    assert_match ':success=&gt;10', email.body.to_s
    assert_match ':failure=&gt;2', email.body.to_s
    assert_match ':success=&gt;15', email.body.to_s
    assert_match ':failure=&gt;0', email.body.to_s
  end

  test "uri_analysis" do
    report_file_path = '/path/to/uri_analysis_report.csv'
    
    email = AdminMailer.uri_analysis(report_file_path)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ['geoportal@btaa.org', 'majew030@umn.edu', 'ewlarson@gmail.com', 'mjb@umn.edu'], email.to
    assert_equal 'noreply@example.com', email.from[0]
    assert_equal 'B1G GeoBOT - URI Analysis Report', email.subject
    assert_match report_file_path, email.body.to_s
  end
end
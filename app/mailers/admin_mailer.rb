class AdminMailer < ApplicationMailer
  default from: 'no-reply@geo.btaa.org'

  def image_states(rake_results)
    @results = rake_results
    mail(to: 'majew030@umn.edu, ewlarson@gmail.com', subject: 'B1G GeoBOT - Image Harvest States')
  end

  def uri_analysis(report_file_path)
    @report = report_file_path
    mail(to: 'majew030@umn.edu, ewlarson@gmail.com', subject: 'B1G GeoBOT - URI Analysis Report')
  end
end

class AdminMailer < ApplicationMailer
  default from: 'no-reply@geo.btaa.org'

  def image_states(rake_results)
    @results = rake_results
    mail(to: 'btaa-gdp@umn.edu, geoportal@btaa.org', subject: 'B1G GeoBOT - Image Harvest States')
  end
end

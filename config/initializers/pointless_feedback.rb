PointlessFeedback.setup do |config|
  # ==> Feedback Configuration
  # Configure the topics for the user to choose from on the feedback form
  config.message_topics = ['Correction', 'Question', 'Comments or Suggestions', 'Other']

  # ==> Email Configuration
  # Configure feedback email properties (disabled by default)
  # Variables needed for emailing feedback
  config.email_feedback            = true
  config.send_from_submitter       = true
  # config.from_email                = 'no-reply@geo.btaa.org'
  config.to_emails                 = ['ewlarson@umn.edu','btaa-gdp@umn.edu','geoportal@btaa.org']
  config.google_captcha_site_key   = ENV["GEOPORTAL_CAPTCHA_SITE_KEY"]
  config.google_captcha_secret_key = ENV["GEOPORTAL_CAPTCHA_SECRET_KEY"]
end

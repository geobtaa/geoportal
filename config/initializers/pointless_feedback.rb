# PointlessFeedback
=begin
PointlessFeedback.setup do |config|
  # ==> Feedback Configuration
  # Configure the topics for the user to choose from on the feedback form
  config.message_topics = ['Correction', 'Question', 'Comments or Suggestions', 'Harmful language', 'Other']

  # ==> Email Configuration
  # Configure feedback email properties (disabled by default)
  # Variables needed for emailing feedback
  config.email_feedback            = true
  config.send_from_submitter       = false
  config.from_email                = 'no-reply@geo.btaa.org'
  config.to_emails                 = ['btaa-gdp@umn.edu','geoportal@btaa.org']
  config.google_captcha_site_key   = ENV["GEOBLACKLIGHT_CAPTCHA_SITE_KEY"]
  config.google_captcha_secret_key = ENV["GEOBLACKLIGHT_CAPTCHA_SECRET_KEY"]
end
=end
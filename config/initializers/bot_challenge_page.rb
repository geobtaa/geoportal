Rails.application.config.to_prepare do

  BotChallengePage::BotChallengePageController.bot_challenge_config.enabled = ENV['TURNSTILE_ENABLED']

  # Get from CloudFlare Turnstile: https://www.cloudflare.com/application-services/products/turnstile/
  # Some testing keys are also available: https://developers.cloudflare.com/turnstile/troubleshooting/testing/
  #
  # Always pass testing sitekey: "1x00000000000000000000AA"
  BotChallengePage::BotChallengePageController.bot_challenge_config.cf_turnstile_sitekey = ENV['TURNSTILE_SITE_KEY']
  # Always pass testing secret_key: "1x0000000000000000000000000000000AA"
  BotChallengePage::BotChallengePageController.bot_challenge_config.cf_turnstile_secret_key = ENV['TURNSTILE_SECRET_KEY']

  BotChallengePage::BotChallengePageController.bot_challenge_config.redirect_for_challenge = true


  # How long will a challenge success exempt a session from further challenges?
  # BotChallengePage::BotChallengePageController.bot_challenge_config.session_passed_good_for = 36.hours

  # Exempt some requests from bot challenge protection
  # BotChallengePage::BotChallengePageController.bot_challenge_config.allow_exempt = ->(controller) {
  #   # controller.params
  #   # controller.request
  #   # controller.session

  #   # Here's a way to identify browser `fetch` API requests; note
  #   # it can be faked by an "attacker"
  #   controller.request.headers["sec-fetch-dest"] == "empty"
  # }

  # More configuration is available


end

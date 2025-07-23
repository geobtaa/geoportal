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

  WORMLY_UA_REGEX    = /WormlyBot/i
  APPSIGNAL_UA_REGEX = /AppSignalBot/i

  BotChallengePage::BotChallengePageController.bot_challenge_config.allow_exempt = lambda do |controller, _config|
    # Ajax/facet exemption
    ajax_search =
      controller.params[:action].in?(%w[facet range_limit]) &&
      controller.request.headers["sec-fetch-dest"] == "empty" &&
      controller.is_a?(CatalogController)

    # Monitoring bots, detected solely by UA
    ua = controller.request.user_agent.to_s
    wormly_bot    = ua.match?(WORMLY_UA_REGEX)
    appsignal_bot = ua.match?(APPSIGNAL_UA_REGEX)

    ajax_search || wormly_bot || appsignal_bot
  end
end

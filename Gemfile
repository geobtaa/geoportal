source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.1.0'
gem 'bootsnap', '~> 1.9.3', require: false
gem 'listen', '~> 3.0'

gem 'rack-cors', :require => 'rack/cors'

gem "puma", "~> 5.1"
# Run puma with systemd integration
gem 'sd_notify', '>= 0.1.0'

# Webpacker
gem 'webpacker', '~> 4.x'

gem 'sqlite3', '~> 1.4'
#gem 'mysql2', '~> 0.5.0'
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Profiling stuff
gem 'rack-mini-profiler', '~> 2.3.1'
gem 'flamegraph', '~> 0.9.5'
gem 'stackprof', '~> 0.2.12' # ruby 2.1+ only
gem 'memory_profiler', '~> 0.9.12'

group :development, :test do
  gem 'active_record_query_trace'
  
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # RSpec/SolrWrapper
  gem 'axe-core-api'
  gem 'capybara'
  gem 'capybara-selenium'
  gem 'capybara-screenshot'
  gem 'selenium-webdriver'
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'rspec-rails', '~> 3.5'
  gem 'spring'
end

group :development do
  gem 'web-console'
  gem 'foreman'
  gem 'letter_opener'
end

gem 'blacklight', '~> 7.33.0'

# BL Advanced Search / Pinned to EWL bug-fix
# See: https://github.com/projectblacklight/blacklight_advanced_search/issues/127
gem "blacklight_advanced_search", git: "https://github.com/ewlarson/blacklight_advanced_search.git", branch: "bl7-fix-gentle-hands"

gem 'blacklight_range_limit', '~> 7.0.0'
gem 'chosen-rails', '~> 1.10' #  jquery multiselect plugin for advanced search
gem 'bootstrap', '~> 4.0'
gem 'popper_js'
gem 'twitter-typeahead-rails', '0.11.1.pre.corejavascript'
gem 'geoblacklight', '~> 4.1'
gem 'geoblacklight_admin', "~> 0.4.0"
gem "rubyzip", ">= 1.3.0"
gem "awesome_print"

# GBL Admin dependencies _not_ automatically loading...
gem 'active_storage_validations'
gem 'awesome_print'
# gem 'blacklight_advanced_search'
gem 'dotenv-rails'
gem 'haml'
gem 'inline_svg'
gem 'kithe', '~> 2.0'
gem 'noticed'
gem 'paper_trail'

# Image migration
gem 'geoblacklight_sidecar_images', git: "https://github.com/geoblacklight/geoblacklight_sidecar_images.git", branch: "feature/statesman-update"
gem 'carrierwave', '~> 1.2'
gem 'mini_magick', '~> 4.9.4'
gem "image_processing", ">= 1.2"

gem 'statesman', '~> 10.0'
gem 'sidekiq', '~> 6.4'
gem 'sidekiq-failures', '~> 1.0.0'
gem 'down', '~> 5.0'
gem 'addressable', '~> 2.5.0'
gem 'handlebars_assets', '~> 0.23.0'
gem 'geoblacklight-icons', git: 'https://github.com/geoblacklight/geoblacklight-icons.git', :ref => '84da81140e7ef93e7241b7753c01d7f709216f2b'
gem 'solr_wrapper', git: 'https://github.com/cbeer/solr_wrapper.git', branch: 'master'

gem 'rsolr', '>= 1.0'
gem 'jquery-rails'

# Auth
gem "devise", "4.7.3"
gem 'devise-bootstrap-views', '~> 1.0'
gem 'devise-guests', '~> 0.6'
gem 'devise_invitable', '~> 2.0.0'

# Reporting
gem 'blazer'

gem 'haml'
gem 'chronic'

# Dotenv
gem 'dotenv-rails'

# Feedback
gem 'pointless_feedback'
gem 'whenever', '~> 1.0.0', require: false
gem 'sitemap_generator', '~> 6.0.2'
gem 'exception_notification', '~> 4.4.0'

# Appsignal
gem 'appsignal'

group :test do
  gem 'm', '~> 1.5.0'
  gem 'minitest'
  gem 'minitest-ci', '~> 3.4.0'
  gem 'minitest-reporters'
end

gem 'rexml'

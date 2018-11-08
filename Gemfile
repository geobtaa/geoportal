source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.4'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
gem 'mysql2', '0.4.8'
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

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Guard
  gem 'guard' # NOTE: this is necessary in newer versions
  gem 'guard-minitest'
  gem 'terminal-notifier-guard'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 3.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'capistrano', '3.4.1'
  gem 'capistrano-rails'
  gem 'capistrano-template'
  gem 'capistrano-bundler'
  gem 'capistrano-passenger'
  gem 'capistrano-maintenance'

  gem 'puma'
  gem 'foreman'
end

gem 'blacklight', '>= 6.3'
gem 'blacklight_advanced_search'
gem 'blacklight_range_limit'
gem 'chosen-rails' #  jquery multiselect plugin for advanced search
gem 'geoblacklight', '~> 1.9.0'
gem 'geoblacklight_sidecar_images', git: 'https://github.com/ewlarson/geoblacklight_sidecar_images.git', :ref => '3fd6634dc3dfa089d7894620c0fbf15571ab5625'
gem 'statesman', '~> 3.4.1'
gem 'sidekiq', '~> 5.1.3'
gem 'sidekiq-failures', '~> 1.0.0'
gem 'down', '~> 4.4'
gem 'addressable', '~> 2.5.0'
gem 'inline_svg', '~> 1.3.0'
# gem 'geoblacklight-icons', '~> 1.2.0'
gem 'handlebars_assets', '~> 0.23.0'
gem 'geoblacklight-icons', git: 'https://github.com/geoblacklight/geoblacklight-icons.git', :ref => '84da81140e7ef93e7241b7753c01d7f709216f2b'
gem 'solr_wrapper', git: 'https://github.com/cbeer/solr_wrapper.git', branch: 'master'

gem 'rsolr', '>= 1.0'
gem 'jquery-rails'
gem 'devise'
gem 'devise-guests', '~> 0.6'

gem 'haml'

# Static Pages
gem 'high_voltage', '~> 3.0.0'
gem 'jekyll'
gem 'jekyll-feed'

# Feedback
gem 'pointless_feedback'

gem 'whenever', '~> 0.9.0', require: false
gem 'sitemap_generator', '~> 5.2.0'
gem 'exception_notification', '~>4.2.0'

group :test do
  gem 'minitest-rails-capybara', '~>3.0.0'
  gem 'chromedriver-helper'
  gem 'capybara-selenium'
end

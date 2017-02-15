# Use this file to easily define all of your cron jobs.
# Learn more: http://github.com/javan/whenever
set :job_template, "bash -l -c 'export PATH=:rbenv_path/bin::rbenv_path/shims:$PATH; eval \"$(rbenv init -)\"; RBENV_VERSION=:rbenv_ruby BUNDLE_GEMFILE=:path/Gemfile :job RAILS_ENV=:environment'"

job_type :sitemap_refresh, 'cd :path && bundle exec rake sitemap:refresh'
job_type :user_cleanup, 'cd :path && bundle exec rake devise_guests:delete_old_guest_users[2]'
job_type :search_cleanup, 'cd :path && bundle exec rake blacklight:delete_old_searches[7]'
job_type :logrotate, '/usr/sbin/logrotate -s :path/tmp/logrotate.state :path/config/logrotate.conf > /dev/null'

every :day, at: '12:30am', roles: [:app] do
  sitemap_refresh nil
end
every :day, at: '1:30am', roles: [:app] do
  user_cleanup nil
end
every :day, at: '2:30am', roles: [:app] do
  search_cleanup nil
end

set :job_template, nil
every :day, at: '12:00am', roles: [:app] do
  logrotate nil
end

# Use this file to easily define all of your cron jobs.
# Learn more: http://github.com/javan/whenever
set :job_template, "bash -l -c 'BUNDLE_GEMFILE=:path/Gemfile :job RAILS_ENV=:environment'"

#job_type :sitemap_refresh, 'cd :path && bundle exec rake sitemap:refresh'
#job_type :user_cleanup, 'cd :path && bundle exec rake devise_guests:delete_old_guest_users[2]'
#job_type :search_cleanup, 'cd :path && bundle exec rake blacklight:delete_old_searches[7]'
job_type :logrotate, '/usr/sbin/logrotate -s :path/../../shared/tmp/logrotate.state :path/config/logrotate.conf > /dev/null'

every :day, at: '12:05am', roles: [:app] do
  # Harvest thumbnail images for search results
  rake 'geoportal:queue_incomplete_states'
end
every :day, at: '12:30am', roles: [:app] do
  rake 'sitemap:refresh'
end
every :day, at: '1:30am', roles: [:app] do
  rake 'blacklight:delete_old_guest_users[2]'
end
every :day, at: '2:30am', roles: [:app] do
  rake 'blacklight:delete_old_searches[7]'
end
every :day, at: '3:00am', roles: [:app] do
  # Check image harvest state and email results
  rake 'geoportal:sidecar_states'
end
# URI analysis
every '0 1 1 * *', roles: [:app] do
  rake 'geoportal:uri_purge'
end
every '0 2 1 * *', roles: [:app] do
  rake 'geoportal:uri_process_all'
end
every '0 1 2 * *', roles: [:app] do
  rake 'geoportal:uri_queue_incomplete_states'
end
every '0 8 2 * *', roles: [:app] do
  rake 'geoportal:uri_report'
end

set :job_template, nil
every :day, at: '12:00am', roles: [:app] do
  logrotate nil
end

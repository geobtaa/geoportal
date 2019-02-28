# Use this file to easily define all of your cron jobs.
# Learn more: http://github.com/javan/whenever
set :job_template, "bash -l -c 'BUNDLE_GEMFILE=:path/Gemfile :job RAILS_ENV=:environment'"

job_type :sitemap_refresh, 'cd :path && bundle exec rake sitemap:refresh'
job_type :user_cleanup, 'cd :path && bundle exec rake devise_guests:delete_old_guest_users[2]'
job_type :search_cleanup, 'cd :path && bundle exec rake blacklight:delete_old_searches[7]'
job_type :logrotate, '/usr/sbin/logrotate -s :path/../../shared/tmp/logrotate.state :path/config/logrotate.conf > /dev/null'

# Harvest thumbnail images for search results
job_type :harvest_images, 'cd :path && bundle exec rake geoportal:queue_incomplete_states'

# Check image harvest state and email results
job_type :email_image_harvest_results, 'cd :path && bundle exec rake geoportal:sidecar_states'

every :day, at: '12:05am', roles: [:app] do
  harvest_images nil
end
every :day, at: '12:30am', roles: [:app] do
  sitemap_refresh nil
end
every :day, at: '1:30am', roles: [:app] do
  user_cleanup nil
end
every :day, at: '2:30am', roles: [:app] do
  search_cleanup nil
end
every :day, at: '3:00am', roles: [:app] do
  email_image_harvest_results nil
end

set :job_template, nil
every :day, at: '12:00am', roles: [:app] do
  logrotate nil
end

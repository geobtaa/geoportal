# Use this file to easily define all of your cron jobs.
# Learn more: http://github.com/javan/whenever
set :job_template, "bash -l -c 'export PATH=:rbenv_path/bin::rbenv_path/shims:$PATH; eval \"$(rbenv init -)\"; RAILS_ENV=:environment RBENV_VERSION=:rbenv_ruby BUNDLE_GEMFILE=:path/Gemfile :job'"

job_type :sitemap_refresh, 'cd :path && bundle exec rake sitemap:refresh'
job_type :user_cleanup, 'cd :path && bundle exec rake devise_guests:delete_old_guest_uesrs[2]'
job_type :search_cleanup, 'cd :path && bundle exec rake geoblacklight:delete_old_searches[7]'

every :day, at: '12:30am', roles: [:app] do
  sitemap_refresh nil
end
every :day, at: '1:30am', roles: [:app] do
  user_cleanup nil
end
every :day, at: '2:30am', roles: [:app] do
  search_cleanup nil
end

# Use this file to easily define all of your cron jobs.
# Learn more: http://github.com/javan/whenever
set :job_template, "bash -l -c 'export PATH=:rbenv_path/bin::rbenv_path/shims:$PATH; eval \"$(rbenv init -)\"; RAILS_ENV=:environment RBENV_VERSION=:rbenv_ruby BUNDLE_GEMFILE=:path/Gemfile :job'"

job_type :sitemap_refresh, 'bundle exec rake sitemap:refresh'

every :day, at: '12:30am', roles: [:app] do
  sitemap_refresh nil
end

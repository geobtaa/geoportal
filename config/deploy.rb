# config valid only for current version of Capistrano
lock '3.4.1'

set :application, 'geoblacklight'
#set :repo_url, 'git@github.umn.edu:Libraries/geoblacklight.git'
set :repo_url, 'git@github.com:BTAA-Geospatial-Data-Project/geoportal.git'

set :passenger_restart_with_touch, true

# Default branch is :master
# Prompt to choose a tag (or name a branch), default to last listed tag
# unless an environment variable was passed on the command line as in:
# $ GEOBLACKLIGHT_RELEASE=1.0.0 bundle exec cap development deploy
unless ARGV.include?('deploy:rollback')
  avail_tags = `git tag --sort=version:refname`
  set :branch, (ENV['GEOBLACKLIGHT_RELEASE'] || ask("release tag or branch:\n #{avail_tags}", avail_tags.chomp.split("\n").last))
end

set :deploy_user, 'swadm'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/swadm/var/www/#{fetch(:application)}"

# Forces crontab surrounding comments to include deploy target
set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:rails_env)}"}

set :whenever_variables, ->{ "'environment=#{fetch :whenever_environment}'" }

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
#set :linked_files, fetch(:linked_files, []).push('config/blacklight.yml', 'config/database.yml', 'config/solr.yml', 'config/secrets.yml')
set :linked_files, []

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'public/system', 'public/uploads')

# tmp directory is user-specific
set :tmp_dir, "/tmp/#{fetch(:deploy_user)}"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

namespace :deploy do
  #beforIe :symlink do
    desc 'Place templated files'
    task :templates do
      on roles(:app) do
        template 'logrotate.conf', "#{fetch(:release_path)}/config/logrotate.conf"
      end
    end
  #end

  after :restart, :clear_cache do
    on roles(:app) do
      # Here we can do anything such as:
      within release_path do
        # Refresh the Google/Crawler Sitemap
        execute :rake, 'sitemap:refresh', "RAILS_ENV=#{fetch(:rails_env)}"

        # Load the centroid JSON data for homepage map
        execute :rake, 'geoportal:generate_centroids_json', "RAILS_ENV=#{fetch(:rails_env)}"

        # Stop and Restart Sidekiq
        execute :rake, 'geoportal:sidekiq_stop', "RAILS_ENV=#{fetch(:rails_env)}"
        execute :rake, 'geoportal:sidekiq_start', "RAILS_ENV=#{fetch(:rails_env)}"
      end
    end
  end
end

after 'deploy:symlink:shared', 'deploy:templates'

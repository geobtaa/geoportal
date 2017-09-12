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
set :deploy_to, "/swadm/usr/local/#{fetch(:application)}"

# Forces crontab surrounding comments to include deploy target
set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:rails_env)}"}

set :whenever_variables, ->{ "'environment=#{fetch :whenever_environment}}'" }

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
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'public/system')

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
        execute :rake, 'sitemap:refresh', "RAILS_ENV=#{fetch(:rails_env)}"
        # No need to generate centroids - EWL
        # execute :rake, 'geoportal:generate_centroids_solr', "RAILS_ENV=#{fetch(:rails_env)}"
        execute :rake, 'geoportal:generate_centroids_json', "RAILS_ENV=#{fetch(:rails_env)}"
      end
    end
  end

  desc 'Set group-writable permissions on release dir for non-swadm user'
  task :set_group_writable do
    unless fetch(:deploy_user) == 'swadm'
      on roles(:app, :web, :db) do
        # Goal is to make the release swadm owned, and also all precompiled assets swadm owned,group, & group writable
        # Sprockets monkeys with permissions causing the group sticky bit not to apply when precompiling assets.
        #
        # This method means non-swadm users can deploy without their SSH keys known to swadm, so we don't have to allow
        # map library staff to put their keys in swadm's .ssh/authorized_keys.
        #
        # 1. Set swadm group on the release
        execute "chgrp -R swadm #{release_path}"
        # 2. Make the release group writable
        execute "chmod -R g+rw #{release_path}"
        # 3. Set group write on precompiled assets, but only those owned by the user who deployed (because of sprockets)
        # Must be done as the owning user, cannot sudo this.
        execute "find #{shared_path}/tmp/cache/assets/sprockets -user #{fetch(:deploy_user)} -exec chmod -R g+rw {} \\;"
        # Finally, give swadm ownership of everything now that
        execute "sudo chown -R -h swadm #{release_path}"
        execute "sudo chown -R -h swadm #{shared_path}/tmp/cache"
      end
    end
  end
end

after 'deploy:symlink:shared', 'deploy:templates'
after 'deploy:updated', 'deploy:set_group_writable'

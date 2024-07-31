# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require File.expand_path('../config/initializers/solr_wrapper', __FILE__)
require 'solr_wrapper/rake_task'

Rails.application.load_tasks
require 'blacklight/allmaps/rake_task'
require "geoblacklight_admin/rake_task"

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require File.expand_path('../config/initializers/solr_wrapper', __FILE__)
require 'solr_wrapper/rake_task'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.pattern = "test/test_*.rb"
end

task :default => :test


Rails.application.load_tasks

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

SolrWrapper.default_instance_options = {
    verbose: false,
    cloud: false,
    port: '8983',
    version: '5.5.0',
    instance_dir: 'solr',
    download_dir: 'tmp'
}
require 'solr_wrapper/rake_task'


Rails.application.load_tasks

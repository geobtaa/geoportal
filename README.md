### Installing rbenv
#### Main rbenv system
```
git clone https://github.com/rbenv/rbenv.git /swadm/usr/local/rbenv

# Ruby-build subsystem
git clone https://github.com/rbenv/ruby-build.git /swadm/usr/local/rbenv/plugins/ruby-build

# Add to path and bootstrap command in (for swadm shell usage)
# rbenv may act strangely in particular using ruby-build if it isn't in the homedir
ln -s /swadm/usr/local/rbenv /home/swadm/.rbenv
echo 'export PATH="/swadm/usr/local/rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile

# Source the profile file to load this environment in the current shell.

# Install ruby, set it as default
rbenv install 2.3.0
rbenv global 2.3.0
```

### Setup the rails application (from scratch)
```
# Install Rails core
gem install rails

# Create new Rails project and bootstrap geoblacklight
cd /swadm/usr/local
rails new geoblacklight
```

That may not succeed outright because it tries to run generators depending on
a JS runtime that hasn't been loaded. 

Edit geoblacklight/Gemfile to uncomment therubyracer

#### Add to Gemfile

```ruby
gem 'geoblacklight'

# Only needed/used until solr_wrapper gets new release beyond 0.10.0, should be soon...
gem 'solr_wrapper', git: 'https://github.com/cbeer/solr_wrapper.git', branch: 'master'
```

```shell
# Reload dependencies
bundle install

# Regenerate templates
rails generate blacklight:install --devise
rails generate geoblacklight:install
```


#### Geoblacklight guided install directions end up with Solr 4.x running in jetty
Some tweaks were needed to get the geoblacklight solr config in the right place.
Add to Rakefile config for solr

```ruby
SolrWrapper.default_instance_options = {
    verbose: false,
    cloud: false,
    port: '8983',
    version: '5.5.0',
    instance_dir: 'solr',
    download_dir: 'tmp'
}
require 'solr_wrapper/rake_task'
```

```shell
$ rake solr:clean
$ mkdir jetty

# Symlink helps the `rake geoblacklight:configure_solr` task find solr
# Won't be necessary if solr is already setup
$ cd jetty && ln -s ../solr/server/solr solr
```


#### Now it should be possible to start solr
```shell
$ rake solr:start
```

Visit https://lib-geoblacklightdev.oit.umn.edu:8983 to verify Solr is running

### Load test records into Solr
Geoblacklight has sample records, but its seeding rake task won't find them. They can be copied into the project

```shell
$ mkdir -p spec/fixtures/solr_documents
# Copy them from the gem install in rbenv
$ cp /swadm/usr/local/rbenv/versions/2.3.0/lib/ruby/gems/2.3.0/gems/geoblacklight-0.12.1/spec/fixtures/solr_documents/* spec/fixtures/solr_documents

# Now it should be possible to load them
$ bundle exec rake geoblacklight:solr:seed
```

### View the site
Restart Apache to make sure the rails application is up, and visit https://lib-geoblacklightdev.oit.umn.edu

### NOTE ABOUT devise
Instructions say to pass the --devise flag to setup devise in the application. 
It's used for authentication, but I am omitting it until we know what we we'll use.

For now, the thing is wide open.

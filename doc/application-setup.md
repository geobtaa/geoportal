# Setup the rails application (from scratch)

## Prerequisites
Assumes you have already:
- [Setup rbenv and installed Ruby](/doc/rbenv-setup.md)
- [Setup Apache & Passenger](/doc/apache-passenger.md)

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


#### Divert from Geoblacklight guided install
As of April 2016, Geoblacklight's guided install winds up with Solr 4.x. We've added the `solr_wrapper` gem used by newer Blacklight versions and it facilitates installation of Solr 5.x and simple controls for development.

Added to Rakefile config for solr

```ruby
# Rakefile
require 'solr_wrapper/rake_task'
```

#### Override Solr Defaults
By default, Solr will attempt to install in `/swadm/usr/local/solr`. This path 
can be overridden (especially for local development) along with other options in 
`config/solr.yml`.  See [config/solr-example.yml](`config/solr-example.yml) for 
available settings and their defaults.

For local development, assuming no `/swadm` tree is available, set 
`instance_dir` to a path where you can run Solr as a user on your workstation:

```yaml
instance_dir: /home/you/solr
```


#### Download Solr
Now it should be possible to start solr in the default or configured location
```shell
# Download if not already done
$ rake solr:clean
$ rake solr:start
```

#### Install Blacklight Solr core config
The [Geoblacklight schema](https://github.com/geoblacklight/geoblacklight-schema) project
provided initial Solr core & schema configs for Geoblacklight. Locally, those 
live in our own repository at 
https://github.umn.edu/Libraries/geoblacklight-solr-config. Follow its README to 
load the repository and symlink it into Solr as a core. Then restart Solr and 
the `blacklightcore` core should now be listed in the Solr admin screen.

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





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

#### Start Solr
Now it should be possible to start solr in the default or configured location
```shell
# Download if not already done
$ rake solr:clean
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


## Passenger install procedure
Passenger is installed as a Ruby gem, which builds an Apache module.

```shell
# 1. Install the gem for the specific Ruby version in rbenv (--no-rdoc, --no-ri skip installing docs)
$ RBENV_VERSION=2.3.0 gem install passenger --no-rdoc --no-ri

# 2. Build the apache module (select only Ruby)
$ passenger-install-apache2-module
```

### Enable Passenger in Apache config:

#### Basic setup
```
#####
# /swadm/etc/httpd/conf.d/00-passenger.conf
# In its own file to control load order and make it easier to find when ruby versions change...
#####

LoadModule passenger_module /swadm/usr/local/rbenv/versions/2.3.0/lib/ruby/gems/2.3.0/gems/passenger-5.0.27/buildout/apache2/mod_passenger.so
<IfModule mod_passenger.c>
  PassengerRoot /swadm/usr/local/rbenv/versions/2.3.0/lib/ruby/gems/2.3.0/gems/passenger-5.0.27
  PassengerDefaultRuby /swadm/usr/local/rbenv/versions/2.3.0/bin/ruby
</IfModule>
```

#### VirtualHost config
```
######
# /swadm/etc/httpd/conf.d/geoblacklightdev.conf
######

# Document root must point to public directory
DocumentRoot /swadm/usr/local/geoblacklightdev/public

<Directory "/swadm/usr/local/geoblacklightdev">
    # Locate application, passenger will autodetect Rails
    PassengerAppRoot "/swadm/usr/local/geoblacklightdev"

    # Path we'll expose to the web
    PassengerBaseURI /
    
    # Make sure it's in development mode (default is production)
    PassengerAppEnv "development"

    # .. rest of normal Apache conf stuff..
</Directory>
```

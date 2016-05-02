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


#### Divert from Geoblacklight guided install
As of April 2016, Geoblacklight's guided install winds up with Solr 4.x under 

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

Visit https://lib-geoblacklightdev.oit.umn.edu:8983 to verify Solr is running

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
# In its own file to control load order and make it easier to find when ruby 
versions change...
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

## Local Development Quickstart
Geoblacklight should be fairly easy to run using conventional local Rails 
development procedures (localhost:3000, sqlite3)

```shell
# Clone the repository, and cd into it
$ git clone git@github.umn.edu:Libraries/geoblacklight.git
$ cd geoblacklight

# Configure a sqlite3 databse, copy the example config
$ cp config/database-example.yml config/database.yml
# Edit the DB config to uncomment the sqlite development setup
$ $EDITOR config/database.yml

# Configure a solr download location
# Copy the example solr config and set instance_dir to anywhere that makes sense 
# on your development system
$ cp config/solr-example.yml config/solr.yml
$ $EDITOR config/solr.yml

# For instance, the solr/ directory inside(relative) the project is 
# probably fine
# ...in config/solr.yml...
# instance_dir: solr

# Rails initialization stuff...

# Bundler dependencies
$ bundle install

# Database initialization
$ bundle exec rake db:migrate

# Solr download (ONLY IF NOT ALREADY INSTALLED)
$ rake solr:clean

# Obtain geoblacklight Solr config, symlink into <solr instance_dir>/server/solr/blacklightcore
# Details at https://github.umn.edu/Libraries/geoblacklight-solr-config
$ cd /somewhere/you/keep/sourcecode && git clone git@github.umn.edu:Libraries/geoblacklight-solr-config.git

# Link the solr config into place
$ ln -s /somewhere/you/keep/sourcecode/geoblacklight-solr-config /your/solr/instance_dir/server/solr/blacklightcore

# Start your development Solr
$ cd /back/to/geoblacklight
$ bundle exec rake solr:start


# Load some sample documents into Solr
$ bundle exec rake geoblacklight:solr:seed

# Check http://localhost:8983 to verify Solr is running 
# and has some documents loaded

# Start the Rails bundled development webserver
$ bundle exec rails server
```

If everything went correctly, you are now running a web server on 
`127.0.0.1:3000` and your browser should show a working Geoblacklight at 
http://localhost:3000 and it should be searchable with a handful of documents in 
Solr.

Solr's status should be visible at http://localhost:8983.



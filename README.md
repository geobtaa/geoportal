# Geoblacklight

Server-specific setup docs are located in the [`doc/`](/doc) directory.

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



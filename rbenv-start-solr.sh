#!/bin/bash
#
# Start jetty wrapper around Solr, first bootstrapping rbenv
# Run from cron as /swadm/usr/local/geoblacklightdev/rbenv-start-jetty.sh
#
export PATH=/swadm/usr/local/rbenv/bin:/swadm/usr/local/rbenv/shims:$PATH;
eval "$(rbenv init -)";
RBENV_VERSION=2.3.0 BUNDLE_GEMFILE=/swadm/usr/local/geoblacklightdev/Gemfile bundle exec rake solr:start

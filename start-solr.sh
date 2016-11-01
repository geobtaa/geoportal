#!/bin/bash
#
# Start solr with a simple bin/solr start
#
# It may be necessary to specify the $JAVA_HOME environment variable
# For example, on a swadm VM this may be run at startup as
# $ JAVA_HOME=/swadm/usr/java /path/to/geoblacklight/start-solr.sh
cd /swadm/usr/local/solr && bin/solr start

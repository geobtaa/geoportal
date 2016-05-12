# Solr Config
Solr lives at `/swadm/usr/local/solr`

## Start Solr at boot
Solr can be started by its Rake task (with all necessary rbenv environment using
```shell
$ rake solr:start
```

Doing so merely invokes solr's normal startup. Swadm's crontab `@reboot` is 
configured to call a solr startup sript:


```shell
# Swadm's crontab:
@reboot /swadm/usr/local/geoblacklight/current/start-solr.sh
```

See also [Solr Defaults and Overriding](/README.md) in the project's main 
`README.md`

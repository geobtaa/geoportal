# Setup for OIT swadm VMs

### Libraries 'swadm' servers


**GeoNetwork Production**  
lib-geonet.oit.umn.edu  
alias: geonet.lib.umn.edu  
134.84.231.51  
RHEL 6 64-bit / 2 CPU / 4 GB RAM

Network Summary: Public IP space, https://geonet.lib.umn.edu is world accessible, Apache + mod_proxy make Tomcat port 8080 available as /geonetwork/ via SSL only.  OIT's enterprise MySQL production server mysql-prod1.oit.umn.edu accepts traffic via port 3306 from this VM.

Zabbix Monitoring: Lib\_Maps group.  Template\_Libraries\_Apache, Template\_Libraries\_Linux, Template\_Libraries\_Tomcat (port 8080 listening), Template\_OIT\_Ping\_Only.
<br><br>

**GeoNetwork Development**  
lib-geonetdev.oit.umn.edu  
alias: geonetdev.lib.umn.edu  
134.84.231.41  
RHEL 6 64-bit / 2 CPU / 4 GB RAM

Network Summary: Public IP space, https://geonetdev.lib.umn.edu is world accessible, Apache + mod_proxy make Tomcat port 8080 available as /geonetwork/ via SSL only.  OIT's enterprise MySQL development server mysql-dev1.oit.umn.edu accepts traffic via port 3306 from this VM.

Zabbix Monitoring: Lib\_Maps group.  Template\_Libraries\_Apache, Template\_Libraries\_Linux, Template\_Libraries\_Tomcat (port 8080 listening), Template\_OIT\_Ping\_Only.
<br><br>

**GeoBlackLight Production**  
lib-geoblacklight.oit.umn.edu  
134.84.231.232  
RHEL 6 64-bit / 2 CPU / 8 GB RAM

Network Summary:  Apache and mod_proxy to make Solr port 8983 available as /solr/ via SSL only.  Basic Auth authentication is required.  Still in development, web access is limited to the UMN VPN range.

Zabbix Monitoring: Lib\_Maps group.  Template\_Libraries\_Apache, Template\_Libraries\_Linux, Template\_Libraries\_Solr (port 8983 listening), Template\_OIT\_Ping\_Only.
<br><br>

**GeoBlackLight Development**  
lib-geoblacklightdev.oit.umn.edu  
134.84.231.239  
RHEL 6 64-bit / 2 CPU / 6 GB RAM

Network Summary:  Apache and mod_proxy to make Solr port 8983 available as /solr/ via SSL only.  Basic Auth authentication is required.  Still in development, web access is limited to the UMN VPN range.

Zabbix Monitoring: Lib\_Maps group.  Template\_Libraries\_Apache, Template\_Libraries\_Linux, Template\_Libraries\_Solr (port 8983 listening), Template\_OIT\_Ping\_Only.

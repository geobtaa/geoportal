# AWS EC2 Hostname Deploy Notes

The legacy Rails app can run with its AWS public DNS name as the canonical URL:

```sh
GEOPORTAL_APP_URL=https://ec2-3-143-166-108.us-east-2.compute.amazonaws.com
GEOPORTAL_DEFAULT_URL_HOST=ec2-3-143-166-108.us-east-2.compute.amazonaws.com
```

`GEOPORTAL_APP_URL` is the preferred setting. `GEOPORTAL_DEFAULT_URL_HOST` is kept for older deploy scripts that only know about a bare host.

Before deploying, audit the server environment and remove or replace any old value like:

```sh
GEOPORTAL_DEFAULT_URL_HOST=geo.btaa.org
```

`GEOPORTAL_APP_URL` wins when both variables are set.

## Nginx

The EC2 host must stop redirecting HTTP requests to `geo.btaa.org`. The nginx site should use the AWS hostname as its `server_name`, preserve the incoming host when proxying to Rails, and redirect plain HTTP to the same host:

```nginx
server {
  listen 80;
  server_name ec2-3-143-166-108.us-east-2.compute.amazonaws.com;

  location /.well-known/acme-challenge/ {
    root /var/www/html;
  }

  location / {
    return 301 https://$host$request_uri;
  }
}

server {
  listen 443 ssl http2;
  server_name ec2-3-143-166-108.us-east-2.compute.amazonaws.com;

  ssl_certificate /etc/letsencrypt/live/ec2-3-143-166-108.us-east-2.compute.amazonaws.com/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/ec2-3-143-166-108.us-east-2.compute.amazonaws.com/privkey.pem;

  location / {
    proxy_set_header Host $host;
    proxy_set_header X-Forwarded-Host $host;
    proxy_set_header X-Forwarded-Proto https;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_pass http://127.0.0.1:3000;
  }
}
```

Adjust the upstream port if Puma is listening somewhere other than `127.0.0.1:3000`.

## Certificate

The currently installed certificate is for `geo.btaa.org`, so browsers will reject it for the AWS hostname. Issue or install a certificate whose SAN includes:

```text
ec2-3-143-166-108.us-east-2.compute.amazonaws.com
```

With certbot/nginx, the shape is usually:

```sh
sudo certbot --nginx -d ec2-3-143-166-108.us-east-2.compute.amazonaws.com
sudo nginx -t
sudo systemctl reload nginx
```

If certificate issuance fails for the AWS-owned hostname, the durable fix is to use a BTAA-controlled legacy hostname instead and set `GEOPORTAL_APP_URL` to that URL.

## Capistrano

This app repo no longer contains Capistrano files. Git history says the deploy file was removed because the real deploy lives in the separate UMN repo:

```text
/Users/ewlarson/Rails/clients/b1g/geomg-deploy
```

That deploy repo generates `shared/.env.production` from:

```text
config/deploy/templates/shared/template.env.erb
```

The production stage currently sets:

```ruby
set :geoblacklight_url, 'https://geo.btaa.org'
```

Change it to:

```ruby
set :geoblacklight_url, 'https://ec2-3-143-166-108.us-east-2.compute.amazonaws.com'
```

Then add the canonical app URL to `template.env.erb` near the Blacklight URL settings:

```erb
GEOPORTAL_APP_URL='<%= fetch(:geoblacklight_url) %>'
GEOPORTAL_DEFAULT_URL_HOST='ec2-3-143-166-108.us-east-2.compute.amazonaws.com'
```

`BLACKLIGHT_JSON_API`, `BLACKLIGHT_JSON_API_FACETS`, and `BLACKLIGHT_JSON_API_IDS` should be relative paths, because GeoBlacklight Admin prefixes them with the current request host:

```erb
BLACKLIGHT_JSON_API='/admin/api.json'
BLACKLIGHT_JSON_API_FACETS='/admin/advanced_search/facets.json'
BLACKLIGHT_JSON_API_IDS='/admin/api/ids.json'
```

The application now normalizes old absolute values to paths at boot, but keeping the deploy template path-based avoids the admin landing page constructing invalid URLs after sign-in.

Normal deploys only check that `shared/.env.production` exists. They do not regenerate it. After changing the deploy repo, either rerun:

```sh
bundle exec cap production setup:secrets
```

or manually update `/var/www/geomg/shared/.env.production` on the server before deploying/restarting.

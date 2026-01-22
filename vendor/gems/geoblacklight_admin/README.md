# geoblacklight_admin

![CI](https://github.com/geobtaa/geoblacklight_admin/actions/workflows/ci.yml/badge.svg)

GeoBlacklight Admin is a [GeoBlacklight](https://github.com/geoblacklight/geoblacklight) plugin, built on [Kithe](https://github.com/sciencehistory/kithe), that provides a complex web-form for editing documents and an CSV-based import/export workflow for OpenGeoMetadata's [Aardvark schema](https://opengeometadata.org/ogm-aardvark/). GBL Admin is based on the Big Ten Academic Alliance's production workflow tool [GEOMG](https://github.com/geobtaa/geomg).

[![GeoBlackliht Admin](https://raw.githubusercontent.com/geobtaa/geoblacklight_admin/develop/docs/gbl_admin_screenshot.png)](https://youtu.be/lWjcr-Ow228 "GeoBlacklight Admin")

## Requirements

* Rails v7 (not v8)
* Blacklight v7 (not v8)
* GeoBlacklight v4 (not v5)
* @geoblacklight/frontend v4 (NPM package)
* Solr v8.4+
* PostgreSQL (not MySQL-based DBs)
* Redis (for Sidekiq)
* OpenGeoMetadata's Aardvark Schema

## Installation

### PostgreSQL

You need a PostgreSQL database to use this project.

* Homebrew: https://wiki.postgresql.org/wiki/Homebrew
* Docker: https://www.docker.com/blog/how-to-use-the-postgres-docker-official-image/

### Install Template

#### 1. Create your geoblacklight_admin_development PostgreSQL database

```bash
psql postgres
CREATE DATABASE geoblacklight_admin_development;
```

#### 2. Bootstrap a new GeoBlacklight + GBL Admin application using the template script:

```bash
rails _7.2.2_ new gbl_admin -m https://raw.githubusercontent.com/geobtaa/geoblacklight_admin/develop/template.rb
cd gbl_admin
bundle exec rake geoblacklight:server
```

You have now generated the .internal_test_app and populated the Elements / FormElements tables for OMG Aardvark support.

### View App in Browser

1. Visit http://localhost:3000/admin
2. Click on the "Sign in" link
3. Enter email: admin@geoblacklight.org and password: 123456
4. Click on the "GBL Admin" link
5. Import some CSV data (test/fixtures/files/btaa_sample_records.csv)

-----

## Contributing

For Developer documentation see [doc/developer.md](./docs/development.md)

## License
The gem is available as open source under the terms of the [Apache 2.0 License](https://opensource.org/license/apache-2-0).

## TODOs / Roadmap
* ~~Send GBLADMIN JavaScript pack to NPM like Blacklight~~
* ~~Improve test coverage~~
* ~~Fix CI test runner~~
* ~~Debug Rails 7.2 support (remove devise_invitable, see [#915](https://github.com/scambra/devise_invitable/issues/915))~~
* ~~Separate dct_references_s support into a separate model~~
* ~~Import/Export dct_references_s outside of the main document model~~
* ~~Distributions: Move import to background queue~~
* ~~Data Dictionary: Add support for `document_data_dictionary`~~
* Gazetteer: Add GeoNames support
* Gazetteer: Add Who's On First support
* Gazetteer: Add Ollama support
* Gazetteer: Add BTAA spatial file support
* Migrate our GBL API controllers to just RSolr-based models
* DRY up Gem dependencies and Engine routing
* Remove any remaining GEOMG references
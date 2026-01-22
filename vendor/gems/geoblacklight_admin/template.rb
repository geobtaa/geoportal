# frozen_string_literal: true

##### INSTALL NOTES #####
#
# 1. Create your geoblacklight_admin_development PostgreSQL database
#
# $> psql postgres
# $> CREATE DATABASE geoblacklight_admin_development;
#
# 2. Run these lines below to stand up a new GBL + GBL Admin instance:
#
# $> rails _7.2.2_ new gbl_admin -m https://raw.githubusercontent.com/geobtaa/geoblacklight_admin/develop/template.rb
# $> cd gbl_admin
# $> bundle exec rake geoblacklight:server
#

gem "devise"
gem "blacklight", ">= 7.0", "< 8.0"
gem "geoblacklight", ">= 4.0"
gem "geoblacklight_admin", git: "git@github.com:geobtaa/geoblacklight_admin.git", branch: "develop"

# GBL‡ADMIN
gem "active_storage_validations"
gem "awesome_print"
gem "blacklight_advanced_search"
gem "dotenv-rails"
gem "haml"
gem "inline_svg"
gem "kithe", "~> 2.0"
gem "noticed"
gem "paper_trail"
gem "pagy", "~> 9.0"

run "bundle install"

generate "blacklight:install", "--devise"
generate "geoblacklight:install", "--force"
generate "blacklight_advanced_search:install", "--force"
generate "geoblacklight_admin:install", "--force"

rake "db:migrate"
rake "db:seed"

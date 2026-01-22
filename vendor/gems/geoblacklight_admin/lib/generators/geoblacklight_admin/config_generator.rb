# frozen_string_literal: true

require "rails/generators"

module GeoblacklightAdmin
  class ConfigGenerator < Rails::Generators::Base
    source_root File.expand_path("templates", __dir__)

    desc <<-DESCRIPTION
      This generator makes the following changes to your application:
       1. Copies GBL Admin initializer files to host config
       2. Copies database.yml connection to host config
       3. Copies sidekiq.yml connection to host config
       5. Copies .env.development and .env.test to host
       4. Copies settings.yml to host config
       5. Copies .solr_wrapper.yml to host config
       6. Copies JSON Schema to host
       7. Copies solr/* to host
       8. Sets Routes
       set_development_mailer_host
       11.Sets DB Seeds
       12.Sets Pagy Backend
       11.Sets ActiveStorage
       add_api_controller
       add_user_util_links
       copy_catalog_index_view
       add_show_sidebar
       copy_app_javascript
       copy_app_images
       add_package_json
       add_assets_initialier
       add_kithe_bulk_loading_service
       add_kithe_model_to_solr_document
       add_search_builder_publication_state_concern
       add_import_id_facet
       add_vite_rails_config
    DESCRIPTION

    def create_gbl_admin_initializer_files
      copy_file "config/initializers/geoblacklight_admin.rb", "config/initializers/geoblacklight_admin.rb", force: true
      copy_file "config/initializers/devise.rb", "config/initializers/devise.rb", force: true
      copy_file "config/initializers/kithe.rb", "config/initializers/kithe.rb", force: true
      copy_file "config/initializers/mime_types.rb", "config/initializers/mime_types.rb", force: true
      copy_file "config/initializers/pagy.rb", "config/initializers/pagy.rb", force: true
      copy_file "config/initializers/shrine.rb", "config/initializers/shrine.rb", force: true
      copy_file "config/initializers/simple_form.rb", "config/initializers/simple_form.rb", force: true
      copy_file "config/initializers/simple_form_bootstrap.rb", "config/initializers/simple_form_bootstrap.rb", force: true
      copy_file "config/initializers/statesman.rb", "config/initializers/statesman.rb", force: true
    end

    def create_database_yml
      copy_file "config/database.yml", "config/database.yml", force: true
    end

    def create_sidekiq_yml
      copy_file "config/sidekiq.yml", "config/sidekiq.yml", force: true
    end

    def create_solr_wrapper_yml
      copy_file ".solr_wrapper.yml", ".solr_wrapper.yml", force: true
    end

    def create_dotenv
      copy_file ".env.development.example", ".env.development"
      copy_file ".env.development.example", ".env.test"
    end

    def create_settings_yml
      copy_file "config/settings.yml", "config/settings.yml", force: true
    end

    def copy_json_schema
      copy_file "config/geomg_aardvark_schema.json", "config/geomg_aardvark_schema.json"
    end

    def copy_solr
      directory "solr", "solr", force: true
    end

    def set_routes
      gbl_admin_routes = <<-ROUTES
        ####################
        # GBL‡ADMIN

        # Bulk Actions
        resources :bulk_actions do
          patch :run, on: :member
          patch :revert, on: :member
        end

        # Users
        devise_for :users, skip: [:registrations]
        as :user do
          get "/sign_in" => "devise/sessions#new" # custom path to login/sign_in
          get "/sign_up" => "devise/registrations#new", :as => "new_user_registration" # custom path to sign_up/registration
          get "users/edit" => "devise/registrations#edit", :as => "edit_user_registration"
          put "users" => "devise/registrations#update", :as => "user_registration"
        end

        namespace :admin do
          # Root
          root to: "documents#index"

          # Assets
          # Note "assets" is Rails reserved word for routing, oops. So we use
          # asset_files.
          resources :assets, path: "asset_files" do
            collection do
              get "display_attach_form"
              post "attach_files"

              get "destroy_all"
              post "destroy_all"
            end

            post :sort, on: :collection
          end

          # Bulk Actions
          resources :bulk_actions do
            patch :run, on: :member
            patch :revert, on: :member
          end

          # Imports
          resources :imports do
            resources :mappings
            resources :import_documents, only: [:show]
            patch :run, on: :member
          end

          # Import Distributions
          resources :import_distributions do
            resources :import_document_distributions, only: [:show]
            patch :run, on: :member
          end

          # Elements
          resources :elements do
            post :sort, on: :collection
          end

          # Form Elements
          resources :form_elements do
            post :sort, on: :collection
          end
          resources :form_header, path: :form_elements, controller: :form_elements
          resources :form_group, path: :form_elements, controller: :form_elements
          resources :form_control, path: :form_elements, controller: :form_elements
          resources :form_feature, path: :form_elements, controller: :form_elements

          # Reference Types
          resources :reference_types do
            post :sort, on: :collection
          end

          # Notifications
          resources :notifications do
            put "batch", on: :collection
          end

          # Users
          get "users/index"

          # Bookmarks
          resources :bookmarks
          delete "/bookmarks", to: "bookmarks#destroy", as: :bookmarks_destroy_by_fkeys

          # Search controller
          get "/search" => "search#index"
          
          # AdvancedSearch controller
          get '/advanced_search' => 'advanced_search#index', constraints: lambda { |req| req.format == :json }
          get '/advanced_search/facets' => 'advanced_search#facets', constraints: lambda { |req| req.format == :json }
          get '/advanced_search/facet/:id' => 'advanced_search#facet', constraints: lambda { |req| req.format == :json }, as: 'advanced_search_facet'

          # Ids controller
          get '/api/ids' => 'ids#index', constraints: lambda { |req| req.format == :json }
          get '/api' => 'api#index', constraints: lambda { |req| req.format == :json }
          get '/api/fetch' => 'api#fetch', constraints: lambda { |req| req.format == :json }
          get '/api/facet/:id' => 'api#facet', constraints: lambda { |req| req.format == :json }

          # Documents
          resources :documents do
            get "admin"
            get "versions"

            collection do
              get "fetch"
            end

            # DocumentLicensedAccesses
            resources :document_licensed_accesses, path: "licensed_access" do
              collection do
                get "import"
                post "import"

                get "destroy_all"
                post "destroy_all"
              end
            end

            # Document Assets
            resources :document_assets, path: "assets" do
              collection do
                get "display_attach_form"
                post "attach_files"

                get "destroy_all"
                post "destroy_all"
              end
            end

            # Data Dictionaries
            resources :document_data_dictionaries, path: "data_dictionaries" do
              collection do
                get "import"
                post "import"

                get "destroy_all"
                post "destroy_all"
              end

              resources :document_data_dictionary_entries, path: "entries" do
                collection do
                  post "sort"
                  get "destroy_all"
                  post "destroy_all"
                end
              end
            end

            # Document Distributions
            resources :document_distributions, path: "distributions" do
              collection do
                get "display_attach_form"
                post "attach_files"

                get "destroy_all"
                post "destroy_all"
              end
            end
          end

          # Document Licensed Accesses
          resources :document_licensed_accesses, path: "licensed_access" do
            collection do
              get "import"
              post "import"

              get "destroy_all"
              post "destroy_all"
            end
          end

          # Document Distributions
          resources :document_distributions, path: "distributions" do
            collection do
              get "import"
              post "import"

              get "destroy_all"
              post "destroy_all"
            end
          end

          # Document Assets
          resources :document_assets, path: "assets" do
            collection do
              get "display_attach_form"
              post "attach_files"

              get "destroy_all"
              post "destroy_all"
            end
          end

          # Assets
          get "/asset_files/ingest", to: "assets#display_attach_form", as: "assets_ingest"
          post "/asset_files/ingest", to: "assets#attach_files"
          
          # DocumentAssets
          get "/documents/:id/ingest", to: "document_assets#display_attach_form", as: "asset_ingest"
          post "/documents/:id/ingest", to: "document_assets#attach_files"
          
          # Asset Direct Upload
          mount Kithe::AssetUploader.upload_endpoint(:cache) => "/direct_upload", :as => :direct_app_upload

          resources :collections, except: [:show]

          # Note "assets" is Rails reserved word for routing, oops. So we use
          # asset_files.
          resources :assets, path: "asset_files", except: [:new, :create] do
            member do
              put "convert_to_child_work"
            end
          end

          # @TODO
          # mount Qa::Engine => "/authorities"
          mount ActionCable.server => "/cable"

          # @TODO
          # authenticate :user, ->(user) { user } do
            # mount Blazer::Engine, at: "blazer"
          # end
        end
      ROUTES

      inject_into_file "config/routes.rb", gbl_admin_routes, before: /^end/
    end

    def add_gbl_admin_data_dictionariesable
      inject_into_file "config/routes.rb", before: /^end/ do
        "\n        concern :gbl_admin_data_dictionariesable, GeoblacklightAdmin::Routes::DataDictionariesable.new
        resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog' do
          concerns :gbl_admin_data_dictionariesable
        end
        \n\n"
      end
    end

    def set_development_mailer_host
      mailer_host = "\n  config.action_mailer.default_url_options = { :host => 'localhost:3000' }\n"
      inject_into_file "config/environments/development.rb", mailer_host, after: "config.action_mailer.perform_caching = false"
    end

    def set_seeds
      append_to_file "db/seeds.rb" do
        "GeoblacklightAdmin::Engine.load_seed"
      end
    end

    def add_pagy
      inject_into_class "app/controllers/application_controller.rb", "ApplicationController" do
        "  include Pagy::Backend\n" \
      end
    end

    def add_activestorage
      append_to_file "app/assets/javascripts/application.js" do
        "
// Required by GBL Admin
//= require activestorage
//= require geoblacklight_admin"
      end
    end

    def add_api_controller
      copy_file "api_controller.rb", "app/controllers/admin/api_controller.rb"
    end

    def add_user_util_links
      copy_file "_user_util_links.html.erb", "app/views/shared/_user_util_links.html.erb"
    end

    def copy_catalog_index_view
      copy_file "views/_index_split_default.html.erb", "app/views/catalog/_index_split_default.html.erb"
    end

    def add_show_sidebar
      copy_file "_show_sidebar.html.erb", "app/views/catalog/_show_sidebar.html.erb"
    end

    def copy_app_images
      copy_file "images/bookmark-regular.svg", "app/assets/images/bookmark-regular.svg"
      copy_file "images/bookmark-solid.svg", "app/assets/images/bookmark-solid.svg"
    end

    def add_package_json
      copy_file "package.json", "package.json", force: true
    end

    def copy_rake_tasks
      append_to_file "Rakefile", "require \"geoblacklight_admin/rake_task\"\n"
    end

    def add_assets_initialier
      append_to_file "config/initializers/assets.rb" do
        "
        # GBL ADMIN
        Rails.application.config.assets.paths << Rails.root.join('node_modules')
        Rails.application.config.assets.precompile += %w( geoblacklight_admin.js )
        Rails.application.config.assets.precompile += %w[application.js]
        Rails.application.config.assets.precompile += %w[application.css]"
      end
    end

    def add_kithe_bulk_loading_service
      prepend_to_file "app/controllers/catalog_controller.rb" do
        "require 'kithe/blacklight_tools/bulk_loading_search_service'\n\n"
      end

      inject_into_file "app/controllers/catalog_controller.rb", after: "include Blacklight::Catalog" do
        "\n  self.search_service_class = Kithe::BlacklightTools::BulkLoadingSearchService"
      end
    end

    def add_show_gbl_admin_data_dictionaries
      inject_into_file "app/controllers/catalog_controller.rb", after: "# Custom tools for GeoBlacklight" do
        "\n   config.add_show_tools_partial :gbl_admin_data_dictionaries, partial: 'gbl_admin_data_dictionaries', if: proc { |_context, _config, options| options[:document] && options[:document]&.kithe_model&.document_data_dictionaries&.present? }"
      end
    end

    def add_data_dictionaries_action
      inject_into_file "app/controllers/catalog_controller.rb", before: "\nend" do
        "\n  def data_dictionaries
          \n    @response, @documents = action_documents
          \n    respond_to do |format|
          \n      format.html do
          \n        return render layout: false if request.xhr?
          \n        # Otherwise draw the full page
          \n      end
          \n    end
          \n  end"
      end
    end

    def add_kithe_model_to_solr_document
      inject_into_file "app/models/solr_document.rb", after: "include Geoblacklight::SolrDocument" do
        "\n\nattr_accessor :model
        \n def kithe_model
          Kithe::Model.find_by_friendlier_id(self.id)
        end\n\n"
      end
    end

    def add_search_builder_publication_state_concern
      inject_into_file "app/models/search_builder.rb", after: "include Geoblacklight::SuppressedRecordsSearchBehavior" do
        "\n      include GeoblacklightAdmin::PublicationStateSearchBehavior"
      end
    end

    def add_import_id_facet
      inject_into_file "app/controllers/catalog_controller.rb", before: "# Item Relationship Facets" do
        "\nconfig.add_facet_field Settings.FIELDS.B1G_IMPORT_ID, label: 'Import ID', show: false\n"
      end
    end

    def add_application_config_for_psych_time_with_zone
      inject_into_file "config/application.rb", after: "config.generators.system_tests = nil" do
        "\n    config.active_record.yaml_column_permitted_classes = [Symbol, Date, Time, ActiveSupport::TimeWithZone, ActiveSupport::TimeZone]"
      end
    end

    def add_vite_rails_config
      copy_file "base.html.erb", "app/views/layouts/blacklight/base.html.erb", force: true
      copy_file "vite.config.ts", "vite.config.ts", force: true
      copy_file "config/vite.json", "config/vite.json", force: true
      copy_file "frontend/entrypoints/application.js", "app/javascript/entrypoints/application.js", force: true
    end

    # Add test fixture files - Necessary for import background job tests
    def add_test_fixture_files
      copy_file "btaa_sample_records.csv", "test/fixtures/files/btaa_sample_records.csv", force: true
      copy_file "btaa_sample_document_distributions.csv", "test/fixtures/files/btaa_sample_document_distributions.csv", force: true
      copy_file "btaa_sample_document_data_dictionary_entries.csv", "test/fixtures/files/btaa_sample_document_data_dictionary_entries.csv", force: true
    end

    # Run bundle with vite install
    def bundle_install
      Bundler.with_clean_env do
        run "bundle install"
        run "bundle exec vite install"
      end
    end
  end
end

# frozen_string_literal: true

GeoblacklightAdmin::Engine.routes.draw do
  # GBL‡ADMIN
  resources :bulk_actions do
    patch :run, on: :member
    patch :revert, on: :member
  end

  # @TODO - Users
  # devise_for :users, skip: [:registrations]
  # as :user do
  #  get "/sign_in" => "devise/sessions#new" # custom path to login/sign_in
  #  get "/sign_up" => "devise/registrations#new", :as => "new_user_registration" # custom path to sign_up/registration
  #  get "users/edit" => "devise/registrations#edit", :as => "edit_user_registration"
  #  put "users" => "devise/registrations#update", :as => "user_registration"
  # end

  namespace :admin do
    # Root
    root to: "documents#index"

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

    # Elements
    resources :elements do
      post :sort, on: :collection
    end

    # Reference Types
    resources :reference_types do
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

    # Notifications
    resources :notifications do
      put "batch", on: :collection
    end

    # Users
    get "users/index"

    # Bookmarks
    resources :bookmarks
    delete "/bookmarks", to: "bookmarks#destroy", as: :bookmarks_destroy_by_fkeys

    # AdvancedSearch controller
    get "/advanced_search" => "advanced_search#index", :constraints => ->(req) { req.format == :json }
    get "/advanced_search/facets" => "advanced_search#facets", :constraints => ->(req) { req.format == :json }
    get "/advanced_search/facet/:id" => "advanced_search#facet", :constraints => lambda { |req|
                                                                                   req.format == :json
                                                                                 }, :as => "advanced_search_facet"

    # Ids controller
    get "/api/ids" => "ids#index", :constraints => ->(req) { req.format == :json }
    get "/api" => "api#index", :constraints => ->(req) { req.format == :json }
    get "/api/fetch" => "api#fetch", :constraints => ->(req) { req.format == :json }
    get "/api/facet/:id" => "api#facet", :constraints => ->(req) { req.format == :json }

    resources :documents do
      get "versions"
      get "admin"

      resources :document_licensed_accesses, path: "licensed_access" do
        collection do
          get "import"
          post "import"
          get "destroy_all"
          post "destroy_all"
        end
      end

      resources :document_assets, path: "assets" do
        collection do
          get "display_attach_form"
          post "attach_files"

          get "destroy_all"
          post "destroy_all"
        end
      end

      resources :document_downloads, path: "downloads" do
        collection do
          get "import"
          post "import"

          get "destroy_all"
          post "destroy_all"
        end
      end

      resources :document_references, path: "references" do
        collection do
          get "display_attach_form"
          post "attach_files"

          get "import"
          post "import"

          get "destroy_all"
          post "destroy_all"
        end
      end
    end

    resources :document_licensed_accesses, path: "licensed_access" do
      collection do
        get "import"
        post "import"
        get "destroy_all"
        post "destroy_all"
      end
    end

    resources :document_assets, path: "assets" do
      collection do
        get "display_attach_form"
        post "attach_files"

        get "destroy_all"
        post "destroy_all"
      end
    end

    get "/documents/:id/ingest", to: "document_assets#display_attach_form", as: "asset_ingest"
    post "/documents/:id/ingest", to: "document_assets#attach_files"
    # mount Kithe::AssetUploader.upload_endpoint(:cache) => "/direct_upload", :as => :direct_app_upload

    resources :collections, except: [:show]

    # Note "assets" is Rails reserved word for routing, oops. So we use
    # asset_files.
    resources :assets, path: "asset_files", except: %i[new create] do
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
end

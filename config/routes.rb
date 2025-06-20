Rails.application.routes.draw do
  mount ActionCable.server => "/cable"
  
  get 'about', :to => redirect('https://gin.btaa.org/')
  get 'help', :to => redirect('https://gin.btaa.org/guides/')
  get 'robots.:format' => 'robots#robots'
  get '/centroids.json', :to => redirect('/centroids.json')

  # Tableau
  namespace :admin do
    get '/api/tableau_export', to: 'api#tableau_export'
  end

  # Feedback
  mount PointlessFeedback::Engine, :at => '/feedback'

  # Error Pages for exception handling - EWL
  match '/404' => 'errors#not_found', via: :all
  match '/500' => 'errors#internal_server_error', via: :all

  mount Blacklight::Engine => '/'
  mount BlacklightAdvancedSearch::Engine => '/'

  root to: "catalog#index"
  get '/catalog', to: redirect('/')
  concern :searchable, Blacklight::Routes::Searchable.new

  # GEOMG // Metadata Toolkit JSON-API
  # - Only JSON GET requests
  # namespace :admin do
  #  # AdvancedSearch controller
  #  get '/advanced_search' => 'advanced_search#index', constraints: lambda { |req| req.format == :json }
  #  get '/advanced_search/facets' => 'advanced_search#facets', constraints: lambda { |req| req.format == :json }
  #  get '/advanced_search/facet/:id' => 'advanced_search#facet', constraints: lambda { |req| req.format == :json }, as: 'advanced_search_facet'

  #  # Ids controller
  #  get '/api/ids' => 'ids#index', constraints: lambda { |req| req.format == :json }
  #  get '/api' => 'api#index', constraints: lambda { |req| req.format == :json }
  #  get '/api/fetch' => 'api#fetch', constraints: lambda { |req| req.format == :json }
  #  get '/api/facet/:id' => 'api#facet', constraints: lambda { |req| req.format == :json }
  # end

  get '/brand', to: 'brand#index'

  resource :catalog, only: [:index], as: 'catalog', path: '/catalog', controller: 'catalog' do
    concerns :searchable
  end

  get '/catalog/:id/admin' => 'catalog#admin', as: 'admin_catalog'

  # devise_for :users

  resources :suggest, only: :index, defaults: { format: 'json' }

  resource :feedback_form, path: 'feedback', only: [:new, :create]
  get 'feedback' => 'feedback_forms#new'

  concern :gbl_exportable, Geoblacklight::Routes::Exportable.new
  concern :gbl_admin_data_dictionariesable, GeoblacklightAdmin::Routes::DataDictionariesable.new

  resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog' do
    concerns :gbl_exportable
    concerns :gbl_admin_data_dictionariesable
  end

  concern :gbl_wms, Geoblacklight::Routes::Wms.new
  namespace :wms do
    concerns :gbl_wms
  end

  concern :gbl_downloadable, Geoblacklight::Routes::Downloadable.new
  namespace :download do
    concerns :gbl_downloadable
  end

  resources :download, only: [:show]

  mount Geoblacklight::Engine => 'geoblacklight'

  concern :exportable, Blacklight::Routes::Exportable.new
  resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog' do
    concerns :exportable
  end

  resources :bookmarks do
    concerns :exportable

    collection do
      delete 'clear'
    end
  end

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
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => "/sidekiq"
  end

  devise_for :users

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

    # DocumentDownloads
    resources :document_downloads, path: "downloads" do
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
        get "display_attach_form"
        post "attach_files"

        get "import"
        post "import"

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

  # Document Downloads
  resources :document_downloads, path: "downloads" do
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
    # @TODO
    authenticate :user, ->(user) { user } do
      mount Blazer::Engine, at: "blazer"
    end
  end

  # Blog redirects
  get '/blog', :to => redirect('https://sites.google.com/umn.edu/btaa-gdp/news')
  get '/blog/index.html', :to => redirect('https://sites.google.com/umn.edu/btaa-gdp/news')
  get '/blog/2016/11/15/announcing-the-btaa-geoportal.html', :to => redirect('https://sites.google.com/umn.edu/btaa-gdp/news/2016/11/15-announcing-the-btaa-geoportal?authuser=0')
  get '/blog/2016/12/01/what-can-i-find-in-the-btaa-geoportal.html', :to => redirect('https://sites.google.com/umn.edu/btaa-gdp/news/2016/12/2016-12-01-what-can-i-find-in-the-btaa-geoporta?authuser=0')
  get '/blog/2016/12/30/new-collections-added-in-december-2016.html', :to => redirect('https://sites.google.com/umn.edu/btaa-gdp/news/2016/12/30-new-collections-added-in-december-2016?authuser=0')
  get '/blog/2017/01/31/whats-new-more-scanned-maps-plus-mn-legislative-gis-data.html', :to => redirect('https://sites.google.com/umn.edu/btaa-gdp/news/2017/01/31-whats-new-more-scanned-maps-plus-mn-legislative-gis-data?authuser=0')
  get '/blog/2017/02/16/love-your-data-week.html', :to => redirect('https://sites.google.com/umn.edu/btaa-gdp/news/2017/02/16-love-your-data-week?authuser=0')
  get '/blog/2017/04/04/springtime-news.html', :to => redirect('https://sites.google.com/umn.edu/btaa-gdp/news/2017/04/04-springtime-news?authuser=0')
  get '/blog/2017/05/02/new-records-and-interface-changes.html', :to => redirect('https://sites.google.com/umn.edu/btaa-gdp/news/2017/05/02-new-records-and-interface-changes?authuser=0')
  get '/blog/2017/06/06/new-records-and-geospatial-metadata-workshop.html', :to => redirect('https://sites.google.com/umn.edu/btaa-gdp/news/2017/06/06-new-records-and-geospatial-metadata-workshop?authuser=0')
  get '/blog/2017/07/24/welcome-to-osu-and-uchicago.html', :to => redirect('https://sites.google.com/umn.edu/btaa-gdp/news/2017/07/24-welcome-to-osu-and-uchicago?authuser=0')
  get '/blog/2017/09/12/new-features.html', :to => redirect('https://sites.google.com/umn.edu/btaa-gdp/news/2017/09/12-new-features?authuser=0')
  get '/blog/2017/12/11/new-gis-scanned-map-records.html', :to => redirect('https://sites.google.com/umn.edu/btaa-gdp/news/2017/12/11-new-gis-scanned-map-records?authuser=0')
  get '/blog/2018/07/08/contributor-spotlight-umn.html', :to => redirect('https://sites.google.com/umn.edu/btaa-gdp/news/2018/07/08-contributor-spotlight-umn?authuser=0')
  get '/blog/2018/08/21/contributor-spotlight-uw-madison.html', :to => redirect('https://sites.google.com/umn.edu/btaa-gdp/news/2018/08/21-contributor-spotlight-uw-madison?authuser=0')
  get '/blog/2018/09/19/contributor-spotlight-msu.html', :to => redirect('https://sites.google.com/umn.edu/btaa-gdp/news/2018/09/19-contributor-spotlight-msu?authuser=0')
  get '/blog/2018/10/17/contributor-spotlight-psu.html', :to => redirect('https://sites.google.com/umn.edu/btaa-gdp/news/2018/10/17-contributor-spotlight-psu?authuser=0')
  get '/blog/2018/11/08/contributor-spotlight-iu.html', :to => redirect('https://sites.google.com/umn.edu/btaa-gdp/news/2018/11/08-contributor-spotlight-iu?authuser=0')
  get '/blog/2018/12/07/contributor-spotlight-osu.html', :to => redirect('https://sites.google.com/umn.edu/btaa-gdp/news/2018/12/07-contributor-spotlight-osu?authuser=0')
  get '/blog/2019/01/29/contributor-spotlight-umich.html', :to => redirect('https://sites.google.com/umn.edu/btaa-gdp/news/2019/01/29-contributor-spotlight-umich?authuser=0')
  get '/blog/2019/01/29/featured-collection-polar-geospatial-center.html', :to => redirect('https://sites.google.com/umn.edu/btaa-gdp/news/2019/01/29-featured-collection-polar-geospatial-center?authuser=0')
  get '/blog/2019/02/28/contributor-spotlight-umd.html', :to => redirect('https://sites.google.com/umn.edu/btaa-gdp/news/2019/02/28-contributor-spotlight-umd?authuser=0')
  get '/blog/2019/02/28/featured-item-map-of-the-nimrod-glacier.html', :to => redirect('https://sites.google.com/umn.edu/btaa-gdp/news/2019/02/28-featured-item-map-of-the-nimrod-glacier?authuser=0')
  get '/blog/2019/03/19/contributor-spotlight-iowa.html', :to => redirect('https://sites.google.com/umn.edu/btaa-gdp/news/2019/03/19-contributor-spotlight-iowa?authuser=0')
  get '/blog/2019/03/19/featured-collection-dc-open-data.html', :to => redirect('https://sites.google.com/umn.edu/btaa-gdp/news/2019/03/19-featured-collection-dc-open-data?authuser=0')
end

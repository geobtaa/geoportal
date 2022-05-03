Rails.application.routes.draw do
  get 'about', :to => redirect('https://sites.google.com/umn.edu/btaa-gdp/about')
  get 'help', :to => redirect('https://sites.google.com/umn.edu/btaa-gdp/help')
  get 'robots.:format' => 'robots#robots'

  # Feedback
  mount PointlessFeedback::Engine, :at => '/feedback'

  # Error Pages for exception handling - EWL
  match '/404' => 'errors#not_found', via: :all
  match '/500' => 'errors#internal_server_error', via: :all

  mount Blacklight::Engine => '/'
  mount BlacklightAdvancedSearch::Engine => '/'

  root to: "catalog#index"
  concern :searchable, Blacklight::Routes::Searchable.new

  # GEOMG // Metadata Toolkit JSON-API
  # - Only JSON GET requests
  namespace :admin do
    # AdvancedSearch controller
    get '/advanced_search/advanced_search_facets' => 'advanced_search#advanced_search_facets', constraints: lambda { |req| req.format == :json }

    # Ids controller
    get '/api/ids' => 'ids#index', constraints: lambda { |req| req.format == :json }
    get '/api' => 'api#index', constraints: lambda { |req| req.format == :json }
    get '/api/fetch' => 'api#fetch', constraints: lambda { |req| req.format == :json }
    get '/api/facet/:id' => 'api#facet', constraints: lambda { |req| req.format == :json }
  end

  resource :catalog, only: [:index], as: 'catalog', path: '/catalog', controller: 'catalog' do
    concerns :searchable
  end

  get '/catalog/:id/admin' => 'catalog#admin', as: 'admin_catalog'

  devise_for :users

  resources :suggest, only: :index, defaults: { format: 'json' }

  resource :feedback_form, path: 'feedback', only: [:new, :create]
  get 'feedback' => 'feedback_forms#new'

  concern :gbl_exportable, Geoblacklight::Routes::Exportable.new
  resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog' do
    concerns :gbl_exportable
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


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

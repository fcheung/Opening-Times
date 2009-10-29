ActionController::Routing::Routes.draw do |map|

  # The priority is based upon order of creation: first created -> highest priority.

  map.root :controller => 'about', :action => 'homepage'
#  map.resources :facilities, :as => 'f'

  map.resources :facilities, :as => 'f', :collection => { :sitemap => :get }, :member => { :remove => :get } do |facilities|
    facilities.resources :revisions, :path_names => { :delete => 'retire' }
    facilities.resources :facility_slug_traps, :as => :slugs
  end

  map.resources :groups, :collection => { :sitemap => :get }
  map.connect 'groups/:id/:page', :controller => :groups, :action => :show, :defaults => { :page => 1 }, :requirements => { :page => /\d*/ } # To allow page caching

  map.search 'search.:format', :controller => 'search', :defaults => { :format => nil }
#  map.fireeagle 'search/fireeagle', :controller => 'search', :action => 'fireeagle'

  map.login "login", :controller => "user_sessions", :action => "new"
  map.logout "logout", :controller => "user_sessions", :action => "destroy"
  map.signup "signup", :controller => "users", :action => "new"

  map.resources :user_sessions
  map.resources :users

  map.compare 'compare/:a/:b', :controller => 'compare', :defaults => { :a => nil, :b => nil }

  ABOUT_PAGES = %w(about accessibility advertising bankholidays copyright feedback guidelines harness help license multipleopenings privacy recentchanges recentlyremoved register sitemap sitemapindex statistics welcome)
  
  ABOUT_PAGES.each do |a|
    map.send "#{a}", "#{a}", :controller => 'about', :action => a
    map.send "#{a}", "#{a}.:format", :controller => 'about', :action => a
  end
  
  map.connect 'services/:id', :controller => 'facilities', :action => 'show' # redirect old urls

  map.reports 'reports/:action/:ip', :controller => 'reports', :defaults => { :ip => nil }, :ip => /\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/

  map.facility_slug ':slug.:format', :controller => 'slug_trap', :action => 'show', :defaults => { :format => nil }, :slug => /[a-z0-9-]+/i

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
#  map.connect ':controller/:action/:id'
#  map.connect ':controller/:action/:id.:format'
end


DrinkChewGuru::Application.routes.draw do
  get "four_square/venue_search"

  get "four_square/check_in"

  get "four_square/post_rview"

  resources :events
  resources :oauth_tokens
  resources :users

  get "users/login"

  get "users/profile"

  get "login/profile"
  
  get "openid/getOpenIdXRD"
  

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  match "privacy", :to => "privacy#policy"
  #users routes
  match "profile", :to=> "users#profile"
  match "login", :to=>"users#login"
  match "user/create", :to=>"users#create"
  match "signout", :to => "users#signout"
  #oauth routes
  match "oauth", :to=> "oauth_tokens#index"
  match "oauth/:provider", :to=>"oauth_tokens#call"
  match "oauth/:provider/callback", :to => "oauth_tokens#create"
  #openid routes
  match "openid", :to=>"openid#openIdButton"
  match "openid/getOpenIdXRD", :to=>"openid#getOpenIdXRD"
    #match "openid/openIdLogin" :to=>"openid#openIdButton"
  #venue routes
  match "venues/search", :to=>"venues#search"
  match "venues/search/results",:to=>"venues#results"
  match "venue/:id",:to=>"venues#display"
  
  #map.connect '/openid', :controller=>'openid', :action=>'openIdLogin'
  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.'
  root :to => "users#login"


  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end

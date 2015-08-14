Rails.application.routes.draw do
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
=begin
  map.connect 'documentation', :controller => 'documentations', :action => 'index'
  map.connect 'documentations/admin', :controller => 'documentations', :action => 'admin'
  map.connect 'license', :controller => 'documentations', :action => 'license'
  map.connect  'about', :controller => 'documentations', :action => 'about'  
  map.connect  'download', :controller => 'documentations', :action => 'download' 
  map.connect  'api', :controller => 'documentations', :action => 'api'
=end
  get 'documentations/license'
  get 'documentations/about'
  get 'documentations/download'
  get 'documentations/api'
  get 'documentations/index'
  
  
  get '/proteins/index'
  get '/proteins/show'
  get '/proteins/show/:id', to: 'proteins#show'
  #get '/proteins' => 'proteins#index'
  #get 'documentation' => 'documentations#index'
  #get 'license' => 'documentations#license'

end

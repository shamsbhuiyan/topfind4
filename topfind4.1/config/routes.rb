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

  #homepage route
  get 'home/index'
  
  #documentations routes
  get 'documentations/license'
  get 'documentations/about'
  get 'documentations/download'
  get 'documentations/api'
  get 'documentations/index'
  
  #proteins routes
  get '/proteins/index'
  get '/proteins/show'
  get '/proteins/show/:id', to: 'proteins#show'
  post '/proteins/show/:id', to: 'proteins#show'
  get '/proteins/filter'
  
  # TOPFINDER
  get '/proteins/topfinder'
  post '/proteins/topfinder_output'
  get 'topfinder', to: 'proteins#topfinder'
  
  # PATHFINDER
  get '/proteins/pathfinder'
  post '/proteins/pathfinder_output'
  get 'pathfinder', to: 'proteins#pathfinder'

  #nterm routes
  get '/nterms/index'
  #get '/nterms/show'
  #get 'nterms/show/:id', to: 'nterms#show'
  get 'show', to: 'nterms#show', as: :nterms_export
  
  #cterms routes
  get '/cterms/index'
  #get '/cterms/show'
  #get 'cterms/show/:id', to: 'cterms#show'
  get 'show', to: 'cterms#show', as: :cterms_export
  
  #terminus modification
  get '/terminusmodifications/index'
  get '/terminusmodifications/show'
  
  # evidences
  get '/evidences/show/:id', to: 'evidences#show'
  
end

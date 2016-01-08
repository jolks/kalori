Rails.application.routes.draw do

  # Better use mostly GET and POST for API because
  # some versions of browsers do not support all HTTP methods.

  root 'sessions#new'
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
  post '/api/login/:user_id' => 'sessions#login_api'
  get '/api/logout/:user_id' => 'sessions#logout_api'

  get 'users/new' => 'users#new'
  post 'users/new' => 'users#create'

  get 'index' => 'calories#index'
  get '/api/calories/exceed/:user_id' => 'calories#exceed_expected_calories'

  get '/api/calories/filter/:user_id' => 'calories#filter_calories'

  get '/api/calories/:user_id' => 'calories#get_all_calories'
  post '/api/calories/:user_id' => 'calories#create_calorie'

  get '/api/calories/:id/user/:user_id' => 'calories#get_calorie'
  post '/api/calories/:id/user/:user_id' => 'calories#update_calorie'
  get '/api/calories/delete/:id/user/:user_id' => 'calories#delete_calorie'

  get '/api/calories/expected/:user_id' => 'calories#get_expected_calories'
  post '/api/calories/expected/:user_id' => 'calories#update_expected_calories'

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
end

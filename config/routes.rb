Rails.application.routes.draw do
  get 'policy_pepole/index'
  get 'person_policy/:mp/:id' => 'policy_pepole#index', as: :show_person_policy 
  get 'policy_divisions/:id/edit' => 'policy_divisions#edit', as: :edit_policy_division
  get 'policy_divisions/:date/:id' => 'policy_divisions#new', as: :new_policy_division
  get 'policy_divisions/:date/:id/policy' => 'policy_divisions#policy', as: :get_policy_division
  resources :policy_divisions
  get 'policies/policy', as: :policies_next
  get 'policies/history/:id' => 'policies#history', as: :history_policy
  resources :policies
  #devise_for :users
  devise_for :users, controllers: { sessions: 'users/sessions', passwords: 'users/passwords', registrations: 'users/registrations', confirmations: 'users/confirmations'  }, path: 'auth', path_names: { sign_in: 'login', sign_out: 'logout', password: 'secret', confirmation: 'verification', unlock: 'unblock', registration: 'register', sign_up: 'cmon_let_me_in' }
  devise_scope :user do
    get '/auth/new_reg', to: "users/registrations#new_reg"
    get '/auth/history', to: "users/registrations#history"
    get '/auth/histories/:user_id', to: "users/registrations#history", as: :user_history
  end
  get 'api/divisions'
  get 'api/division'
  get 'api/policies'
  get 'api/policy'
  get 'api/mp'
  get 'api/mps'

  get 'errors/not_found'

  get 'errors/unacceptable'

  get 'errors/internal_error'

  get 'sumisne-holosuvannia' => 'sumisne_holosuvannia#init', as: :sumisne_holosuvannia
  get 'sumisne-holosuvannia/api' => 'sumisne_holosuvannia#api', as: :sumisne_holosuvannia_api

  get 'help/faq'

  get 'help/data'

  get 'help/licencing'

  get 'divisions' => 'divisions#index', as: :divisions
  get 'divisions/page', as: :divisions_next
  get 'divisions/:date/:id' => 'divisions#show', as: :divisions_show

  get 'people' => 'people#index', as: :people
  get 'people/page', as: :people_next
  get 'people/:mp' => 'people#show', as: :show_people
  get 'people/:mp/divisions' => 'people#divisions', as: :people_divisions
  get 'people/:mp/friends' => 'people#friends', as: :people_friends
  get 'people/:mp/policy' => 'people#policy', as: :people_policy
  get 'people/detal/:mp' => 'people#detal', as: :people_detal

  get 'about' => 'about#index', as: :about
  get 'search_mp' => 'home#search_mp', as: :search_mp
  get 'search' => 'home#search', as: :search
  get 'home/index'
  get "/404", :to => "errors#not_found"
  get "/422", :to => "errors#unacceptable"
  get "/500", :to => "errors#internal_error"


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
   root 'home#index'

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

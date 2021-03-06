ConjugMgr::Application.routes.draw do
  resources :translations

  get "pgroups/index"
  get "pgroup/:id" => "pgroups#show", as: 'pgroup'
  post "pgroups/new"
  get "pgroup/edit/:id" => "pgroups#edit", as: 'pgroup_edit'
  post '/edit_group' => "pgroups#update", as: 'edit_group'
  post '/new_group' => "pgroups#create", as: 'new_group'
  get "pgroups/update"
  get "pgroups/destroy/:id" => "pgroups#destroy", as: 'pgroup_destroy'
  get "translations/accept/:id" => "translations#accept", as: 'translation_accept'


  devise_for :users
  resources :repetitions

  resources :forms

  resources :verbs

  root :to => "verbs#practice"

  get '/download/:page' => 'verbs#download'

  get '/stats' => 'verbs#stats'

  get '/practice' => 'verbs#practice'
  get '/initiate'=> 'verbs#database_initiation'
  get '/from_json/:page' => 'verbs#download_from_json'

  post '/practice' => 'verbs#practice_draw', as: 'practice_draw'

  post '/check_form' => 'verbs#check_form', as: 'check_form'

  post '/report_transl' => 'translations#create', as: 'report_transl'


  post '/add_to_group' => 'verbs#add_to_group', as: 'add_to_group'

  post '/search' => 'verbs#search', as: 'search'

  get '/look_for/:verb' => 'verbs#look_for_conj'

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

  get '*path' => redirect('/')
end

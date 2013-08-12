  Platform::Application.routes.draw do

  devise_for :users

  resources :entries
  resources :articles
  get 'query' => 'query#index'
  get 'query/:level' => 'query#check'
  post 'query/learnt_words'    => 'query#before_this'
  post 'query/marked_words'  
  post 'query/add_marked_word'  
  get 'raffle' => 'raffle#index', :as => 'raffle'
  get 'import' => 'import#index'
  namespace :import do
    post 'article' 
    post 'dictionary' 
    post 'fuzzy' 
  end


  root :to => "articles#index"




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

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'


end

Rails.application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"


  root 'home#index'
  # post 'api/v1/signup' => 'users#create'
  # get 'api/v1/users/:id' => 'users#show'


  scope :api do

    scope :v1 do
      # bookmarks
      scope :bookmarks do
        post '/' => 'bookmarks#create'
      end
      # comment
      scope :comments do
        get '/' => 'comments#show'
        post '/' => 'comments#create'
        patch '/:id' => 'comments#update'
        put '/:id' => 'comments#update'
        delete '/:id' => 'comments#destroy'
      end
      #   post
      scope :posts do
        get '/:id' => 'posts#show'
        post '/' => 'posts#create'
        patch '/:id' => 'posts#update'
        put '/:id' => 'posts#update'
        delete '/:id' => 'posts#destroy'
      end
      # image
      scope :images do
        get '/:id' => 'images#show'
        post '/' => 'images#create'
        patch '/:id' => 'images#update'
        put '/:id' => 'images#update'
        delete '/:id' => 'images#destroy'
      end

      scope :users do
        post '/' => 'users#create'
        get '/:id' => 'users#show'
        patch '/:id' => 'users#update'
      end

      scope :locations do
        get '/:id' => 'locations#show'
        get '/search' => 'locations#search'
      end

      scope :session do
        post '/' => 'session#create'
        get '/' => 'session#destroy'
      end

      scope :home do
        get '/:type' => 'home#get_posts'
      end

      scope :rates do
        post '/' => 'rates#create'
        delete '/:id' => 'rates#destroy'
        patch '/' => 'rates#update'
      end

      scope :cover do
        post '/' => 'cover#update'
      end

      scope :avatar do
        post '/' => 'avatar#update'
      end
    end
  end

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

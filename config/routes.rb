# App::Application.routes.draw do
#   # The priority is based upon order of creation:
#   # first created -> highest priority.

#   # Sample of regular route:
#   #   match 'products/:id' => 'catalog#view'
#   # Keep in mind you can assign values other than :controller and :action

#   # Sample of named route:
#   #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
#   # This route can be invoked with purchase_url(:id => product.id)

#   # Sample resource route (maps HTTP verbs to controller actions automatically):
#   #   resources :products

#   # Sample resource route with options:
#   #   resources :products do
#   #     member do
#   #       get 'short'
#   #       post 'toggle'
#   #     end
#   #
#   #     collection do
#   #       get 'sold'
#   #     end
#   #   end

#   # Sample resource route with sub-resources:
#   #   resources :products do
#   #     resources :comments, :sales
#   #     resource :seller
#   #   end

#   # Sample resource route with more complex sub-resources
#   #   resources :products do
#   #     resources :comments
#   #     resources :sales do
#   #       get 'recent', :on => :collection
#   #     end
#   #   end

#   # Sample resource route within a namespace:
#   #   namespace :admin do
#   #     # Directs /admin/products/* to Admin::ProductsController
#   #     # (app/controllers/admin/products_controller.rb)
#   #     resources :products
#   #   end

#   # You can have the root of your site routed with "root"
#   # just remember to delete public/index.html.
#   # root :to => 'welcome#index'

#   # See how all your routes lay out with "rake routes"

#   # This is a legacy wild controller route that's not recommended for RESTful applications.
#   # Note: This route will make all actions in every controller accessible via GET requests.
#   # match ':controller(/:action(/:id))(.:format)'
# end
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # Autenticación (login)
      post 'auth/login', to: 'authentication#login'

      # Productos más comprados por categoría
      get 'products/index', to: 'products#index'
      get 'products/most_purchased', to: 'products#most_purchased'

      # Top 3 productos con mayor recaudación por categoría
      get 'products/top_revenue', to: 'products#top_revenue'

      # Listado de compras filtrado por parámetros
      get 'purchases', to: 'purchases#index'

      # Cantidad de compras según granularidad (hora, día, semana, año)
      get 'purchases/count', to: 'purchases#count'

      # Cantidad de compras según granularidad (hora, día, semana, año)
      get 'audits', to: 'audits#index'
    end
  end
end

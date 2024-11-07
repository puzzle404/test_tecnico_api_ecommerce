Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do

      # ADMINISTRADORES
      get 'administrators', to: 'administrators#index'
      post 'administrators', to: 'administrators#create'

      # Autenticación (login)
      post 'auth/login', to: 'authentication#login'

      # CLIENTES
      get 'customers', to: 'customers#index'
      post 'customers', to: 'customers#create'

      # CATEGORIAS
      get 'categories', to: 'categories#index'
      post 'categories', to: 'categories#create'
      put 'categories/:id', to: 'categories#update'

      # PRODUCTOS
      get 'products', to: 'products#index'
      post 'products', to: 'products#create'
      put 'products/:id', to: 'products#update'


      # Productos más comprados por categoría
      get 'products/index', to: 'products#index'
      get 'products/most_purchased', to: 'products#most_purchased'

      # Top 3 productos con mayor recaudación por categoría
      get 'products/top_revenue', to: 'products#top_revenue'

      # Listado de compras filtrado por parámetros
      get 'purchases', to: 'purchases#index'

      # COMPRAS
      post 'purchases', to: 'purchases#create'
      # Cantidad de compras según granularidad (hora, día, semana, año)
      get 'purchases/count', to: 'purchases#count'

      # Cantidad de compras según granularidad (hora, día, semana, año)
      get 'audits', to: 'audits#index'
    end
  end
end

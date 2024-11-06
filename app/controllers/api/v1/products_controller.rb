# encoding: utf-8
module Api
  module V1
    class ProductsController < ApplicationController
      before_filter :authenticate_admin! # En Rails 3, se utiliza `before_filter` en lugar de `before_action`

      def index
        products = Product.all
        render json: products
      end

      def most_purchased
        # Buscar todas las categorías
        categories = Category.all
        result = {}

        categories.each do |category|
          # Buscar los productos de esta categoría
          products = category.products.joins(:purchases)
                            .select('products.*, COUNT(purchases.id) as purchases_count')
                            .group('products.id')
                            .order('purchases_count DESC')

          result[category.name] = products.map do |product|
            {
              id: product.id,
              name: product.name,
              purchases_count: product.purchases_count
            }
          end
        end

        render json: result
      end


      def top_revenue
        # Buscar todas las categorías
        categories = Category.all
        result = {}

        categories.each do |category|
          # Buscar los productos de esta categoría
          products = category.products.joins(:purchases)
                            .select('products.*, SUM(purchases.total_price) as total_revenue')
                            .group('products.id')
                            .order('total_revenue DESC')
                            .limit(3) # Obtener solo los 3 con más recaudación

          result[category.name] = products.map do |product|
            {
              id: product.id,
              name: product.name,
              total_revenue: product.total_revenue
            }
          end
        end

        render json: result
      end
    end
  end
end

# encoding: utf-8
module Api
  module V1
    class ProductsController < ApplicationController
      before_filter :authenticate_admin!

      def index
        products = Product.all
        render json: products
      end

      def most_purchased
        result = Category.all.each_with_object({}) do |category, hash|
          products = Product.most_purchased_by_category(category)
          hash[category.name] = products.map do |product|
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
        result = Category.all.each_with_object({}) do |category, hash|
          products = Product.top_revenue_by_category(category)
          hash[category.name] = products.map do |product|
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

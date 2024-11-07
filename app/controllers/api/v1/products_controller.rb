# encoding: utf-8
module Api
  module V1
    class ProductsController < ApplicationController
      before_filter :authenticate_admin!

      def index
        products = Product.all
        render json: products
      end

      def create
        unless Administrator.exists?(id: params[:product][:administrator_id])
          render json: { error: 'Administrator not found' }, status: :not_found
          return
        end

        product = Product.new(product_params)
        if product.save
          render json: product, status: :created
        else
          render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        product = Product.find(params[:id])
        if product.update_attributes(product_params)
          render json: product, status: :ok
        else
          render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
        end
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

      private

      # En Rails 3 no tienes `.permit`, así que debes hacer el filtrado manualmente.
      def product_params
        params[:product].slice(:name, :price, :stock, :description, :administrator_id)
      end
    end
  end
end

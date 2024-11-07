# encoding: utf-8
module Api
  module V1
    class CategoriesController < ApplicationController
      before_filter :authenticate_admin! # Filtrar para asegurar que solo los administradores puedan acceder

      def index
        categories = Category.all
        render json: categories
      end

      def create
        category = Category.new(category_params)
        if category.save
          render json: category, status: :created
        else
          render json: { errors: category.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        category = Category.find(params[:id])
        if category.update_attributes(category_params)
          render json: category, status: :ok
        else
          render json: { errors: category.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def category_params
        params[:category].slice(:name, :description, :administrator_id)
      end
    end
  end
end

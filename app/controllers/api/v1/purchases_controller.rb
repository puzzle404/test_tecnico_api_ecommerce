# encoding: utf-8
module Api
  module V1
    class PurchasesController < ApplicationController
      before_filter :authenticate_admin!

      def index
        # Inicializar las compras sin filtrar como una relación de ActiveRecord
        purchases = Purchase.scoped # Esto mantiene la relación de ActiveRecord en Rails 3

        # Filtrar por fechas si se proporcionan
        if params[:start_date].present? && params[:end_date].present?
          start_date = Date.parse(params[:start_date])
          end_date = Date.parse(params[:end_date])
          purchases = purchases.where(purchase_date: start_date.beginning_of_day..end_date.end_of_day)
        end

        # Filtrar por categoría si se proporciona
        if params[:category_id].present?
          purchases = purchases.joins(product: :categories).where('categories_products.category_id = ?', params[:category_id])
        end

        # Filtrar por cliente si se proporciona
        if params[:customer_id].present?
          purchases = purchases.where(customer_id: params[:customer_id])
        end

        # Filtrar por administrador si se proporciona
        if params[:administrator_id].present?
          purchases = purchases.joins(product: :administrator).where(products: { administrator_id: params[:administrator_id] })
        end

        # Renderizar las compras filtradas
        render json: purchases
      end



      def count
        # Inicializar las compras sin filtrar, siempre como una consulta ActiveRecord::Relation
        purchases = Purchase.scoped

        # Filtrar por fechas si se proporcionan
        if params[:start_date].present? && params[:end_date].present?
          start_date = Date.parse(params[:start_date])
          end_date = Date.parse(params[:end_date])
          purchases = purchases.where(purchase_date: start_date.beginning_of_day..end_date.end_of_day)
        end

        # Filtrar por categoría si se proporciona
        if params[:category_id].present?
          purchases = purchases.joins(product: :category).where(categories: { id: params[:category_id] })
        end

        # Filtrar por cliente si se proporciona
        if params[:customer_id].present?
          purchases = purchases.where(customer_id: params[:customer_id])
        end

        # Filtrar por administrador si se proporciona
        if params[:administrator_id].present?
          purchases = purchases.joins(product: :administrator).where(products: { administrator_id: params[:administrator_id] })
        end

        # Agrupar según la granularidad
        granularity = params[:granularity] || 'hour'

        purchases_count = case granularity
                          when 'hour'
                            purchases.group("DATE_TRUNC('hour', purchase_date)").count
                          when 'day'
                            purchases.group("DATE_TRUNC('day', purchase_date)").count
                          when 'week'
                            purchases.group("DATE_TRUNC('week', purchase_date)").count
                          when 'year'
                            purchases.group("DATE_TRUNC('year', purchase_date)").count
                          else
                            render json: { error: 'Invalid granularity parameter' }, status: :unprocessable_entity and return
                          end

        render json: purchases_count
      end
    end
  end
end

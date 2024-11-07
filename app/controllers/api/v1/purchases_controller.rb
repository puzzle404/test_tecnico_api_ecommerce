# encoding: utf-8
module Api
  module V1
    class PurchasesController < ApplicationController
      before_filter :authenticate_admin!

      def index
        purchases = Purchase.by_date_range(params[:start_date], params[:end_date])
                            .by_category(params[:category_id])
                            .by_customer(params[:customer_id])
                            .by_administrator(params[:administrator_id])

        render json: purchases
      end

      def count
        purchases = Purchase.by_date_range(params[:start_date], params[:end_date])
                            .by_category(params[:category_id])
                            .by_customer(params[:customer_id])
                            .by_administrator(params[:administrator_id])
                            .group_by_granularity(params[:granularity] || 'hour')

        render json: purchases.count
      rescue ArgumentError => e
        render json: { error: e.message }, status: :unprocessable_entity
      end

      def create
        # Verifica que tanto el producto como el cliente existan
        unless Product.exists?(id: params[:purchase][:product_id]) && Customer.exists?(id: params[:purchase][:customer_id])
          render json: { error: 'Product or customer not found' }, status: :not_found
          return
        end

        # Crea la compra si los registros existen
        purchase = Purchase.new(purchase_params)

        if purchase.save
          render json: purchase, status: :created
        else
          render json: { errors: purchase.errors.full_messages }, status: :unprocessable_entity
        end
      end


      private

      def purchase_params
        params[:purchase].slice(:product_id, :customer_id, :purchase_date, :quantity, :total_price)
      end
    end
  end
end

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
    end
  end
end

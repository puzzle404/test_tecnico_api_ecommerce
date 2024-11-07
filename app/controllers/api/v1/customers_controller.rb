# encoding: utf-8
module Api
  module V1
    class CustomersController < ApplicationController
      before_filter :authenticate_admin! # Asegura que solo los administradores puedan acceder

      def index
        customers = Customer.all
        render json: customers
      end

      def create
        customer = Customer.new(customer_params)
        if customer.save
          render json: customer, status: :created
        else
          render json: { errors: customer.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        customer = Customer.find(params[:id])
        if customer.update_attributes(customer_params)
          render json: customer, status: :ok
        else
          render json: { errors: customer.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def customer_params
        params[:customer].slice(:name, :email, :address)
      end
    end
  end
end

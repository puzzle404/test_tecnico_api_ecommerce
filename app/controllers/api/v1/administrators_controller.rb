# encoding: utf-8
module Api
  module V1
    class AdministratorsController < ApplicationController
      before_filter :authenticate_admin! # Asegura que solo los administradores puedan acceder

      def index
        administradors = Administrator.all
        render json: administradors
      end

      def create
        administrator = Administrator.new(administrator_params)
        if administrator.save
          render json: administrator, status: :created
        else
          render json: { errors: administrator.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        administrator = Administrator.find(params[:id])
        if administrator.update_attributes(administrator_params)
          render json: administrator, status: :ok
        else
          render json: { errors: administrator.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def administrator_params
        params[:administrator].slice(:name, :email, :password, :password_confirmation)
      end
    end
  end
end

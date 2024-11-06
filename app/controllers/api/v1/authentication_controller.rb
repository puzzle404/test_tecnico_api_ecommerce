# encoding: utf-8
module Api
  module V1
    class AuthenticationController < ApplicationController
      def login
        admin = Administrator.find_by_email(params[:email])
        if admin && admin.authenticate(params[:password])
          # Establece el tiempo de expiración (por ejemplo, 24 horas desde ahora)
          expiration_time = 1.hours.from_now.to_i
          payload = { admin_id: admin.id, exp: expiration_time }
          token = JWT.encode(payload, ENV['JWT_SECRET_KEY'], 'HS256')
          admin.update_attributes(valid_token: token)
          render json: { token: token, exp: Time.at(expiration_time) }
        else
          render json: { error: 'Invalid credentials' }, status: :unauthorized
        end
      end
    end
  end
end

# encoding: utf-8
require 'spec_helper'
module Api
  module V1
    describe AuthenticationController do
      render_views

      before(:each) do
        @admin = Administrator.create!(
          name: 'Test Admin',
          email: 'test@example.com',
          password: 'password123', # bcrypt se encarga de generar el hash de esta contraseña
          password_confirmation: 'password123' # Asegúrate de que `password_confirmation` esté presente
        )
      end

      describe 'POST #login' do
        context 'with valid credentials' do
          it 'returns a JWT token' do
            post :login, { email: @admin.email, password: 'password123', format: :json }
            expect(response.status).to eq(200)

            body = JSON.parse(response.body)
            expect(body).to have_key('token')
          end
        end

        context 'with invalid credentials' do
          it 'returns unauthorized error' do
            post :login, { email: @admin.email, password: 'wrong_password', format: :json }

            expect(response.status).to eq(401)

            body = JSON.parse(response.body)
            expect(body['error']).to eq('Invalid credentials')
          end
        end
      end
    end
  end
end

# coding: utf-8
source 'https://rubygems.org'

gem 'rails', '3.2.22' # Ya está definido por el proyecto
gem 'pg' # PostgreSQL

# Versiones compatibles para gems problemáticas
gem 'execjs', '<= 2.0.0' # Especificamos una versión anterior compatible
gem 'coffee-rails', '~> 3.2.0' # Versión compatible con Rails 3 y Ruby 1.9.3
gem 'therubyracer', '0.12.2', platforms: :ruby # Versión específica que debería ser más estable
gem 'libv8', '3.16.14.13', platforms: :ruby # Una versión más antigua que puede evitar los problemas de instalación

gem 'sass-rails', '~> 3.2.6' # Asegúrate de usar una versión compatible con Rails 3.2

# Otras dependencias
gem 'uglifier', '>= 1.0.3'
gem 'jquery-rails'
gem 'concurrent-ruby', '1.1.9'

# Versión específica de rake compatible
gem 'rake', '~> 10.5.0'

# Rspec para pruebas (intentar con una versión más estable)
gem 'rspec-rails', '2.14.1' # Versión anterior que debería evitar el problema

gem 'bcrypt-ruby', '3.0.1'
# gem 'bcrypt-ruby', '~> 3.1.5'


#  Paperclip para subir archivos (intentar con una versión más estable)
gem "paperclip"

gem 'climate_control', '~> 0.2.0'


gem 'faker', '1.6.6'


gem 'jwt', '~> 1.5'

gem 'dotenv-rails', groups: [:development, :test]


group :test do
  gem 'database_cleaner', '~> 1.7.0' # Versión compatible con Rails 3 y Ruby 1.9.3
end


gem 'sidekiq', '~> 2.17.8'

gem 'connection_pool', '2.0'

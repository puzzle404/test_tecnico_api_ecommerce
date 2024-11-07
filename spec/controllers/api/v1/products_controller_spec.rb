# encoding: utf-8
require 'spec_helper'
require 'support/authentication_helper'

RSpec.describe Api::V1::ProductsController, type: :controller do
  include AuthenticationHelper

  # Omite el filtro `authenticate_admin!` para los tests de este controlador
  before(:each) do
    Api::V1::ProductsController.skip_before_filter :authenticate_admin!
    # Desactiva los callbacks para el caso del envio de email
    ENV['DISABLE_CALLBACKS_FOR_SEEDS'] = 'true'
  end

  before(:after) do
    ENV.delete('DISABLE_CALLBACKS_FOR_SEEDS')
  end

  describe "GET most_purchased" do
    it "Devuelve los productos más comprados por cada categoría" do
      # Generar el token de autenticación
      token = generate_jwt_token_for_admin

      # Crear categorías
      category1 = Category.create!(name: "Category 1", administrator_id: @admin.id)
      category2 = Category.create!(name: "Category 2", administrator_id: @admin.id)

      # Crear productos asociados a las categorías
      product1 = Product.create!(name: "Product 1", price: 10.0, stock: 100, administrator_id: @admin.id)
      product1.categories << category1

      product2 = Product.create!(name: "Product 2", price: 20.0, stock: 50, administrator_id: @admin.id)
      product2.categories << category2

      product3 = Product.create!(name: "Product 3", price: 15.0, stock: 70, administrator_id: @admin.id)
      product3.categories << category1

      # Crear un cliente
      customer = Customer.create!(name: "Customer 1", email: "customer1@example.com", address: "Address for Customer 1")

      # Registrar compras para cada producto
      Purchase.create!(product_id: product1.id, total_price: 30.0, quantity: 32, customer_id: customer.id)
      Purchase.create!(product_id: product2.id, total_price: 60.0, quantity: 15, customer_id: customer.id)
      Purchase.create!(product_id: product3.id, total_price: 45.0, quantity: 10, customer_id: customer.id)

      # Configurar el header de autorización
      request.headers["Authorization"] = "Bearer #{token}"

      # Realizar la solicitud al método de controlador directamente
      get :most_purchased

      # Verificar la estructura y el contenido de la respuesta
      expect(response.status).to eq(200)
      json = JSON.parse(response.body)

      # Validar la estructura de la respuesta por categorías
      expect(json.keys).to include("Category 1", "Category 2")

      # Verificar los productos en "Category 1"
      expect(json["Category 1"].length).to eq(2)
      expect(json["Category 1"].first["name"]).to eq("Product 1")  # Product con más compras en esta categoría
      expect(json["Category 1"].first["purchases_count"].to_i).to eq(1) # Cambia según las compras registradas
      expect(json["Category 1"].second["name"]).to eq("Product 3")
      expect(json["Category 1"].second["purchases_count"].to_i).to eq(1) # Cambia según las compras registradas

      # Verificar el único producto en "Category 2"
      expect(json["Category 2"].length).to eq(1)
      expect(json["Category 2"].first["name"]).to eq("Product 2")
      expect(json["Category 2"].first["purchases_count"].to_i).to eq(1) # Cambia según las compras registradas
    end
  end

  describe "GET top_revenue" do
    it "Devuelve los 3 productos que más han recaudado por cada categoría" do
      # Generar el token de autenticaciónn
      token = generate_jwt_token_for_admin

      # Crear categorías
      category1 = Category.create!(name: "Category 1", administrator_id: @admin.id)
      category2 = Category.create!(name: "Category 2", administrator_id: @admin.id)

      # Crear productos asociados a las categorías
      product1 = Product.create!(name: "Product 1", price: 10.0, stock: 100, administrator_id: @admin.id)
      product1.categories << category1

      product2 = Product.create!(name: "Product 2", price: 20.0, stock: 50, administrator_id: @admin.id)
      product2.categories << category1

      product3 = Product.create!(name: "Product 3", price: 15.0, stock: 70, administrator_id: @admin.id)
      product3.categories << category1

      product4 = Product.create!(name: "Product 4", price: 25.0, stock: 30, administrator_id: @admin.id)
      product4.categories << category1

      product5 = Product.create!(name: "Product 5", price: 30.0, stock: 40, administrator_id: @admin.id)
      product5.categories << category2

      # Crear un cliente
      customer = Customer.create!(name: "Customer 1", email: "customer1@example.com", address: "Address for Customer 1")

      # Registrar compras con diferentes total_price para simular la recaudación
      Purchase.create!(product_id: product1.id, total_price: 100.0, quantity: 10, customer_id: customer.id)
      Purchase.create!(product_id: product2.id, total_price: 300.0, quantity: 15, customer_id: customer.id)
      Purchase.create!(product_id: product3.id, total_price: 200.0, quantity: 20, customer_id: customer.id)
      Purchase.create!(product_id: product4.id, total_price: 50.0, quantity: 5, customer_id: customer.id)
      Purchase.create!(product_id: product5.id, total_price: 500.0, quantity: 25, customer_id: customer.id)

      # Configurar el header de autorización
      request.headers["Authorization"] = "Bearer #{token}"

      # Realizar la solicitud al método de controlador directamente
      get :top_revenue

      # Verificar la estructura y el contenido de la respuesta
      expect(response.status).to eq(200)
      json = JSON.parse(response.body)

      # Validar la estructura de la respuesta por categorías
      expect(json.keys).to include("Category 1", "Category 2")

      # Verificar los productos en "Category 1"
      expect(json["Category 1"].length).to eq(3) # Solo los 3 productos con más recaudación
      expect(json["Category 1"].first["name"]).to eq("Product 2")  # Producto con más recaudación en Category 1
      expect(json["Category 1"].first["total_revenue"].to_i).to eq(300.0)
      expect(json["Category 1"].second["name"]).to eq("Product 3")
      expect(json["Category 1"].second["total_revenue"].to_i).to eq(200.0)
      expect(json["Category 1"].third["name"]).to eq("Product 1")
      expect(json["Category 1"].third["total_revenue"].to_i).to eq(100.0)

      # Verificar los productos en "Category 2"
      expect(json["Category 2"].length).to eq(1) # Solo un producto en Category 2
      expect(json["Category 2"].first["name"]).to eq("Product 5")
      expect(json["Category 2"].first["total_revenue"].to_i).to eq(500.0)
    end
  end
end

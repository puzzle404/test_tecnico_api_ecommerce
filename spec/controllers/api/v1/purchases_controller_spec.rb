# encoding: utf-8
require 'spec_helper'
require 'support/authentication_helper'

RSpec.describe Api::V1::PurchasesController, type: :controller do
  include AuthenticationHelper

  # Omite el filtro `authenticate_admin!` para los tests de este controlador
  before(:each) do
    Api::V1::PurchasesController.skip_before_filter :authenticate_admin!
    # Crear los datos necesarios para las pruebas
    @admin = Administrator.create!(name: "Admin", email: "admin@example.com", password: 123456)
    @category = Category.create!(name: "Category 1", administrator_id: @admin.id)
    @customer = Customer.create!(name: "Customer 1", email: "customer1@example.com", address: "123 Street")
    @product = Product.create!(name: "Product 1", price: 10.0, stock: 100, administrator_id: @admin.id)
    @purchase = Purchase.create!(product_id: @product.id, customer_id: @customer.id, quantity: 10, total_price: 100.0, purchase_date: Date.today)
    # Desactiva los callbacks para el caso del envio de email
    ENV['DISABLE_CALLBACKS_FOR_SEEDS'] = 'true'
  end

  after(:each) do
    ENV.delete('DISABLE_CALLBACKS_FOR_SEEDS')
  end




  describe "GET #index" do
    it "purchase filter by dates" do
      get :index, start_date: 1.day.ago.to_date.to_s, end_date: Date.today.to_s
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body).size).to eq(1)
    end

    it "purchase filter by category" do
      @product.categories << @category
      get :index, category_id: @category.id
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body).size).to eq(1)
    end

    it "purchase filter by customer" do
      get :index, customer_id: @customer.id
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body).size).to eq(1)
    end

    it "purchase filter by administrator" do
      get :index, administrator_id: @admin.id
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body).size).to eq(1)
    end
  end

  describe "GET #count" do
    it "purchases gruped by granularity equal to hour" do
      get :count, granularity: 'hour', start_date: Date.today.to_s, end_date: Date.today.to_s
      expect(response.status).to eq(200)
      purchases_count = JSON.parse(response.body)
      expect(purchases_count.keys.size).to eq(1)
      expect(purchases_count.values.first).to eq(1)
    end

    it "purchases gruped by granularity equal to day" do
      get :count, granularity: 'day', start_date: Date.today.to_s, end_date: Date.today.to_s
      expect(response.status).to eq(200)
      purchases_count = JSON.parse(response.body)
      expect(purchases_count.keys.size).to eq(1)
      expect(purchases_count.values.first).to eq(1)
    end

    it "purchases gruped by granularity equal to invalid" do
      get :count, granularity: 'invalid'
      expect(response.status).to eq(422)
      error_message = JSON.parse(response.body)["error"]
      expect(error_message).to eq("Invalid granularity parameter")
    end
  end
end

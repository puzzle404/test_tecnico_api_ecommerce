# encoding: utf-8
require 'spec_helper'
require 'support/authentication_helper'

RSpec.describe Purchase, type: :model do
  include AuthenticationHelper

  describe 'send_first_purchase_email' do
    before(:each) do
      # Limpiar todos los correos enviados antes de comenzar la prueba
      ActionMailer::Base.deliveries.clear

      # Crear un administrador y un cliente para asociar con los productos y compras
      @administrator = Administrator.create!(name: "Admin", email: "admin@example.com", password: "password")
      @customer = Customer.create!(name: "Customer 1", email: "customer1@example.com", address: "Customer Address")

      # Crear un producto asociado al administrador
      @product = Product.create!(name: "Test Product", price: 100.0, stock: 20, administrator_id: @administrator.id)
    end

    it 'first purchase of the product email sending' do
      # Crear la primera compra del producto
      purchase = Purchase.create!(product_id: @product.id, customer_id: @customer.id, purchase_date: Date.today, quantity: 1, total_price: 100.0)

      # Verificar que se haya enviado un correo
      expect(ActionMailer::Base.deliveries.count).to eq(1)

      # Verificar que el correo tenga el destinatario adecuado (el administrador)
      mail = ActionMailer::Base.deliveries.last
      expect(mail.to).to include(@administrator.email)
      expect(mail.subject).to eq("Primera compra de #{@product.name}")
    end

    it 'not email sending for for the 2nd purchase of the same product' do
      # Crear dos compras para el mismo producto
      Purchase.create!(product_id: @product.id, customer_id: @customer.id, purchase_date: Date.today, quantity: 1, total_price: 100.0)
      Purchase.create!(product_id: @product.id, customer_id: @customer.id, purchase_date: Date.today, quantity: 1, total_price: 100.0)

      # Verificar que solo se haya enviado un correo (por la primera compra)
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end
  end
end

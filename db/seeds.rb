# encoding: utf-8


require 'faker'

# Limpiar todos los datos existentes
Administrator.destroy_all
Category.destroy_all
Product.destroy_all
Customer.destroy_all
Purchase.destroy_all
Image.destroy_all

# Helper para crear imágenes aleatorias
def random_image_url
  "https://loremflickr.com/300/300/product"
end

# Crear Administradores
admin_count = 3
admins = admin_count.times.map do
  Administrator.create(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    password: 'password123'
  )
end

# Crear Categorías
category_names = ['Electrónica', 'Hogar', 'Deportes', 'Ropa', 'Juguetes', 'Libros', 'Belleza', 'Herramientas']
categories = category_names.map do |category_name|
  Category.create(
    name: category_name,
    description: Faker::Lorem.sentence(8),  # Cambiado para usar un número entero
    administrator_id: admins.sample.id      # Usar el ID en lugar del objeto
  )
end

# Crear Productos y sus Imágenes
product_count = 15
products = product_count.times.map do
  product = Product.create(
    name: Faker::Commerce.product_name,
    description: Faker::Lorem.paragraph(5),  # Cambiado para usar un número entero
    price: Faker::Commerce.price,
    stock: rand(20..150),
    administrator_id: admins.sample.id       # Usar el ID del administrador en lugar del objeto completo
  )

  # Asignar entre 1 a 3 categorías aleatorias al producto
  product.categories << categories.sample(rand(1..3))

  # Crear entre 1 a 3 imágenes para cada producto
  rand(1..3).times do
    product.images.create(url: random_image_url)
  end

  product
end

# Crear Clientes
customer_count = 10
customers = customer_count.times.map do
  Customer.create(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    address: Faker::Address.street_address
  )
end

# Crear Compras
purchase_count = 20
purchase_count.times do
  customer = customers.sample
  product = products.sample
  quantity = rand(1..5)
  Purchase.create(
    customer_id: customer.id,      # Usar customer_id en lugar de customer
    product_id: product.id,        # Usar product_id en lugar de product
    quantity: quantity,
    total_price: product.price * quantity,
    purchase_date: Faker::Date.between(1.year.ago, Date.today)
  )
end

puts "Se han creado #{admin_count} administradores, #{categories.count} categorías, #{product_count} productos, #{customers.count} clientes y #{purchase_count} compras."

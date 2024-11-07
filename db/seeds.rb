# encoding: utf-8


require 'faker'
# Desactiva los callbacks para el caso del envio de email cuando se crea el 1er producto, para que no se envien tantos correos
ENV['DISABLE_CALLBACKS_FOR_SEEDS'] = 'true'

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
Administrator.create(
    name: 'Manuel',
    email: 'cmanuferrer@gmail.com',
    password: '123456'
  )
admin_count = 2
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
    description: Faker::Lorem.sentence(8),
    administrator_id: admins.sample.id
  )
end

# Crear Productos y sus Imágenes
product_count = 15
products = product_count.times.map do
  product = Product.create(
    name: Faker::Commerce.product_name,
    description: Faker::Lorem.paragraph(5),
    price: Faker::Commerce.price,
    stock: rand(20..150),
    administrator_id: admins.sample.id
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
    customer_id: customer.id,
    product_id: product.id,
    quantity: quantity,
    total_price: product.price * quantity,
    purchase_date: Faker::Time.between(1.year.ago, Date.today)
  )
end

# Crear registro auditables para los Productos cuando se editan
products.sample(5).each do |product|
  admin = admins.sample # Selecciona un administrador al azar para esta actualización

  product.update_attributes(price: product.price * 1.1, administrator_id: admin.id) # Llama a log_update y pasa el admin que hizo el cambio
end

puts "Se han creado #{admin_count} administradores, #{categories.count} categorías, #{product_count} productos, #{customers.count} clientes y #{purchase_count} compras."
ENV.delete('DISABLE_CALLBACKS_FOR_SEEDS')

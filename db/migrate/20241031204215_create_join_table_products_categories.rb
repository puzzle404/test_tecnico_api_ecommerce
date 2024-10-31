class CreateJoinTableProductsCategories < ActiveRecord::Migration
   def change
    create_table :categories_products, id: false do |t|
      t.integer :category_id, null: false
      t.integer :product_id, null: false
    end

    # Agregar índices para mejorar las búsquedas
    add_index :categories_products, :category_id
    add_index :categories_products, :product_id
  end
end

class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.integer :customer_id
      t.integer :product_id
      t.integer :quantity
      t.decimal :total_price
      t.datetime :purchase_date

      t.timestamps
    end
  end
end

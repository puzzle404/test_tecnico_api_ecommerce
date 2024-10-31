class Purchase < ActiveRecord::Base
  attr_accessible :customer_id, :product_id, :purchase_date, :quantity, :total_price
  belongs_to :customer
  belongs_to :product
  belongs_to :administrator

  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :total_price, numericality: { greater_than_or_equal_to: 0 }
end

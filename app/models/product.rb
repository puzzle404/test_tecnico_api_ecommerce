class Product < ActiveRecord::Base
  attr_accessible :administrator_id, :description, :name, :price, :stock
  belongs_to :administrator
  has_and_belongs_to_many :categories
  has_many :purchases
  has_many :images

  validates :name, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :stock, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end

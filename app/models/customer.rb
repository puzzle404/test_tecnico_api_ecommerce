class Customer < ActiveRecord::Base
  attr_accessible :address, :email, :name
  has_many :purchases

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :address, presence: true
end

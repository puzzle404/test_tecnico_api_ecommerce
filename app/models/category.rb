class Category < ActiveRecord::Base
  attr_accessible :administrator_id, :description, :name
  belongs_to :administrator
  has_and_belongs_to_many :products

  validates :name, presence: true, uniqueness: true
end

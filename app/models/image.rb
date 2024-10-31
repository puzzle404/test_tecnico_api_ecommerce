class Image < ActiveRecord::Base
  attr_accessible :product_id, :url
  belongs_to :product

  validates :url, presence: true
end

class ProductOrder < ActiveRecord::Base

  validates :order_id, :product_id, :product_count, :unit_price, presence: true

  belongs_to :product
  belongs_to :order
end

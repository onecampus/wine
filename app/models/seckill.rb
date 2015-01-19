class Seckill < ActiveRecord::Base
  validates :product_id, :description, :price, :is_commission, presence: true

  has_many :seckill_orders
  has_many :orders, through: :seckill_orders

  belongs_to :product
end

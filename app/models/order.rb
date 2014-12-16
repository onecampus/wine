class Order < ActiveRecord::Base

  validates :user_id, :mobile, :supplier_id, :total_price, presence: true

  has_many :product_orders
  has_many :products, through: :product_orders

  belongs_to :invoice
end

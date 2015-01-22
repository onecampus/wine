class Group < ActiveRecord::Base
  validates :product_id, :description, :price, :is_commission, presence: true

  has_many :group_orders
  has_many :orders, through: :group_orders

  belongs_to :product
end

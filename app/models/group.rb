class Group < ActiveRecord::Base
  validates :product_id, :description, :price, presence: true

  has_many :group_orders
  has_many :orders, through: :group_orders

  belongs_to :product
end

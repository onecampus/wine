class Order < ActiveRecord::Base

  validates :user_id, :mobile, :supplier_id, :total_price, presence: true

  has_many :product_orders
  has_many :products, through: :product_orders

  belongs_to :invoice
  belongs_to :user

  has_many :group_orders
  has_many :groups, through: :group_orders

  has_many :seclill_orders
  has_many :seclills, through: :seclill_orders

  has_many :commissions
end

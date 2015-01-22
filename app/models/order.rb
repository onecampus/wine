class Order < ActiveRecord::Base

  validates :user_id, :mobile, :supplier_id, :total_price, presence: true

  has_many :product_orders, :dependent => :destroy
  has_many :products, through: :product_orders

  belongs_to :invoice
  belongs_to :user

  has_many :group_orders, :dependent => :destroy
  has_many :groups, through: :group_orders

  has_many :seckill_orders, :dependent => :destroy
  has_many :seckills, through: :seckill_orders

  has_many :commissions

  private

  def self.generate_order_number
    'ZLJYDD' + Time.now.strftime("%Y%m%d%H%M%S%3N")
  end
end

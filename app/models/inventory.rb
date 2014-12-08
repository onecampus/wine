class Inventory < ActiveRecord::Base
  validates :user_id, :product_id, :amount, presence: true

  belongs_to :user
  belongs_to :product
end

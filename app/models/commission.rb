class Commission < ActiveRecord::Base
  validates :user_id, :order_id, :from_user_id, :commission_money, presence: true

  belongs_to :user

  belongs_to :order
end

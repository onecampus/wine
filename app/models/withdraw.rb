class Withdraw < ActiveRecord::Base
  validates :user_id, :draw_money, presence: true

  belongs_to :user
end

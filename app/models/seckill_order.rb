class SeckillOrder < ActiveRecord::Base

  validates :order_id, :seckill_id, :seckill_count, :unit_price, presence: true

  belongs_to :seckill
  belongs_to :order
end

class SeckillOrder < ActiveRecord::Base

  validates :order_id, :seclill_id, :seclill_count, :unit_price, presence: true

  belongs_to :seclill
  belongs_to :order
end

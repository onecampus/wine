class GroupOrder < ActiveRecord::Base

  validates :order_id, :group_id, :group_count, :unit_price, presence: true

  belongs_to :group
  belongs_to :order
end

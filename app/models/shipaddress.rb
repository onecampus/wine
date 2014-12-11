class Shipaddress < ActiveRecord::Base
  validates :user_id, :money, presence: true
  belongs_to :user
end

class Shipaddress < ActiveRecord::Base
  validates :user_id, :receive_name, :province, :city, :region, :address, :mobile, presence: true
  belongs_to :user
end

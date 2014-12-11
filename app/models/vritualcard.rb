class Vritualcard < ActiveRecord::Base
  validates :user_id, :province, :city, :region, :address, :mobile, presence: true

  belongs_to :user
end

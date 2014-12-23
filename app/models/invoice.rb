class Invoice < ActiveRecord::Base
  validates :rise, :content, :user_id, presence: true

  has_many :orders
  belongs_to :user
end

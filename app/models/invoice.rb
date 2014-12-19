class Invoice < ActiveRecord::Base
  validates :rise, :content, presence: true

  has_many :orders
end

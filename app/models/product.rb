class Product < ActiveRecord::Base
  mount_uploader :img, ProductImgUploader

  validates :name, :price, :cat_id, :status, presence: true
  validates :name, uniqueness: true

  belongs_to :cat

  has_many :inventories
  has_many :users, through: :inventories

  has_many :product_orders
  has_many :orders, through: :product_orders

  acts_as_commentable

  has_one :group
  has_one :seckill
end

class Product < ActiveRecord::Base
  mount_uploader :img, ProductImgUploader

  validates :name, :price, :cat_id, :status, presence: true
  validates :name, uniqueness: true

  belongs_to :cat

  has_many :inventories
  has_many :users, through: :inventories

  acts_as_commentable

end

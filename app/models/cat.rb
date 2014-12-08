class Cat < ActiveRecord::Base
  mount_uploader :img, CatImgUploader

  acts_as_nested_set

  include TheSortableTree::Scopes

  validates :name, presence: true
  validates :name, :uniqueness => true

  has_many :products
end

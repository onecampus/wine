class Article < ActiveRecord::Base
  mount_uploader :img, ArticleImgUploader

  validates :title, presence: true
  validates :title, :uniqueness => true
  validates :cat_id, presence: true
  validates :content, presence: true
  validates :summary, presence: true

  belongs_to :cat
  belongs_to :user

  acts_as_taggable

  acts_as_commentable
end

class SiteConfig < ActiveRecord::Base
  mount_uploader :img, SiteConfigImgUploader

  validates :key, presence: true
  validates :key, :uniqueness => true
end

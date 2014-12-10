class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :username,
            uniqueness: {
              case_sensitive: false
            }

  has_one :profile
  has_one :vritualcard
  has_one :integral

  has_many :inventories
  has_many :products, through: :inventories

  has_many :shipaddresses
end

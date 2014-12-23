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
  has_many :invoices

  has_many :orders

  private

  require 'securerandom'
  def self.generate_invite_code
    invite_code = SecureRandom.hex
    'invite_code' + invite_code
  end

  def self.generate_share_link_code
    share_link_code = SecureRandom.uuid
    'share_link_code' + share_link_code
  end
end

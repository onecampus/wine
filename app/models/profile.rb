class Profile < ActiveRecord::Base

  validates :user_id, presence: true

  acts_as_nested_set

  belongs_to :user
end

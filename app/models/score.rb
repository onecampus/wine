class Score < ActiveRecord::Base
  validates :user_id, :mark, presence: true
  belongs_to :user
end

class PrizeAct < ActiveRecord::Base
  validates :name, :prize_type, :is_open, :person_limit, presence: true
  validates :name, uniqueness: true

  has_many :prize_configs
end

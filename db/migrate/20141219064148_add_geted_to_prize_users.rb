class AddGetedToPrizeUsers < ActiveRecord::Migration
  def change
    add_column :prize_users, :geted, :integer
  end
end

class CreatePrizeUsers < ActiveRecord::Migration
  def change
    create_table :prize_users do |t|
      t.integer :user_id
      t.integer :prize_config_id

      t.timestamps
    end
  end
end

class CreatePrizeUserNumbers < ActiveRecord::Migration
  def change
    create_table :prize_user_numbers do |t|
      t.integer :user_id
      t.integer :number
      t.integer :prize_act_id

      t.timestamps
    end
  end
end

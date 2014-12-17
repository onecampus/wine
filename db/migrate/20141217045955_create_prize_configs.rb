class CreatePrizeConfigs < ActiveRecord::Migration
  def change
    create_table :prize_configs do |t|
      t.string :prize_act_id
      t.string :prize_name
      t.string :min
      t.string :max
      t.string :prize_content
      t.integer :prize_inventory
      t.integer :chance

      t.timestamps
    end
  end
end

class CreatePrizeActs < ActiveRecord::Migration
  def change
    create_table :prize_acts do |t|
      t.string :name
      t.string :desc
      t.string :prize_type
      t.datetime :start_time
      t.datetime :end_time
      t.integer :is_open
      t.integer :join_num
      t.integer :person_limit

      t.timestamps
    end
  end
end

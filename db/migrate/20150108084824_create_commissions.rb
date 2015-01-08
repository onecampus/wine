class CreateCommissions < ActiveRecord::Migration
  def change
    create_table :commissions do |t|
      t.integer :user_id
      t.integer :order_id
      t.string :commission_money
      t.string :percent

      t.timestamps
    end
  end
end
